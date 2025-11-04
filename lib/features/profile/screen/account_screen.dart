// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/features/auth/domain/constants/auth_api_constants.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/profile/model/update_user.dart';
import 'package:wintek/features/profile/provider/profile_notifier.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedDate;
  String? selectedGender;
  late TextEditingController nameController;

  static const labelStyle = TextStyle(
    color: Color(0xFFA395EE),
    fontSize: 14,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    height: 1.3,
  );
  static const valueStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    height: 1.57,
  );
  static const fieldPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 18,
  );
  static final fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: Color(0xFFA395EE).withOpacity(0.2)),
  );
  static final focusedFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: Color(0xFFA395EE)),
  );
  static final fieldDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFA395EE).withOpacity(0.2)),
    ),
  );

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentUserDataProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF140A2D),
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(
              'Error loading profile: $error',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          data: (userData) => Builder(
            builder: (context) {
              final data = userData["data"];
              selectedDate ??= data['date_of_birth'] == '-'
                  ? null
                  : data['date_of_birth'];
              selectedGender ??= data['gender'] == '-' ? null : data['gender'];
              nameController.text = data['user_name'] ?? '';
              return FutureBuilder<Widget>(
                future: _buildForm(data),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        spacing: 40,
                        children: [
                          _buildHeader(context),
                          _buildProfileImage(data['picture']),
                          snapshot.data!,
                        ],
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  //
  //
  //
  // App bar section
  //
  //
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              width: 80,
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          // Title
          const Expanded(
            child: Text(
              'My Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
          // Edit button
          GestureDetector(
            onTap: () => _showEditConfirmationDialog(context),
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit, color: Colors.white, size: 14),
                  const SizedBox(width: 8),
                  const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  //
  // Profile Image section
  //
  //
  //

  Widget _buildProfileImage(String? profileImage) {
    final image = profileImage == "-" || profileImage == null
        ? 'https://cdn.vectorstock.com/i/preview-1x/63/42/avatar-photo-placeholder-icon-design-vector-30916342.jpg'
        : profileImage;
    return Stack(
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: AppColors.profileSecondaryColor,
              shape: BoxShape.circle,
            ),
            child: Image.asset(AppImages.cameraIcon),
          ),
        ),
      ],
    );
  }

  //
  //
  // Form section
  //
  //
  //
  Future<Widget> _buildForm(Map<String, dynamic> userData) async {
    final sharedPref = await SharedPreferences.getInstance();
    final isGoogleLog =
        sharedPref.getBool(AuthApiConstants.isGoogleLogin) ?? false;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 20,
          children: [
            _buildFormField(
              label: 'Full Name',
              value: userData['user_name'] ?? 'Add name',
              controller: nameController,
              isEditable: true,
            ),
            if (isGoogleLog) ...[
              _buildFormField(
                label: 'Email',
                value: userData['email'] ?? 'Add email',
                isEditable: false,
              ),
            ],
            if (!isGoogleLog) ...[
              _buildFormField(
                label: 'Phone',
                value: userData['mobile'] ?? 'Add phone number',
                isEditable: false,
              ),
            ],
            _buildFormField(
              label: 'Date of Birth',
              value: selectedDate != null
                  ? _formatDate(DateTime.tryParse(selectedDate!))
                  : 'select',
              onTap: () => _selectDate(context),
              suffixIcon: const Icon(Icons.date_range, color: Colors.white54),
            ),
            _buildGenderField(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String value,
    Widget? suffixIcon,
    VoidCallback? onTap,
    TextEditingController? controller,
    bool isEditable = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 10),
        if (isEditable && controller != null)
          TextFormField(
            controller: controller,
            style: valueStyle,
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              contentPadding: fieldPadding,
              border: fieldBorder,
              enabledBorder: fieldBorder,
              focusedBorder: focusedFieldBorder,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          )
        else
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: fieldPadding,
              decoration: fieldDecoration,
              child: Row(
                children: [
                  Expanded(child: Text(value, style: valueStyle)),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: 14),
                    suffixIcon,
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }

  //

  // Date Section

  //
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate != null
          ? DateTime.tryParse(selectedDate!) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          // Set dialog background to match profile primary color
          dialogBackgroundColor: AppColors.profilePrimaryColor,

          // Customize color scheme for the date picker
          colorScheme: ColorScheme.dark(
            primary: AppColors
                .profileSecondaryColor, // Header and selected date color
            onPrimary: AppColors.profileTextcolor, // Text on primary color
            surface: AppColors.profilePrimaryColor, // Background of calendar
            onSurface: AppColors.profileTextcolor, // Text color on surface
            onSurfaceVariant: Colors.white, // For secondary text
          ),

          // Customize text theme for all text in dialog
          textTheme: Theme.of(context).textTheme.copyWith(
            bodyLarge: const TextStyle(color: Colors.white),
            bodyMedium: const TextStyle(color: Colors.white),
            bodySmall: const TextStyle(color: Colors.white),
            headlineSmall: const TextStyle(color: Colors.white),
            titleLarge: const TextStyle(color: Colors.white),
          ),

          // Customize text button colors
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, // Button text color
            ),
          ),

          // Ensure input text is white for manual entry
          inputDecorationTheme: const InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.white),
            labelStyle: TextStyle(color: Colors.white),
            helperStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white),
            prefixStyle: TextStyle(color: Colors.white),
            suffixStyle: TextStyle(color: Colors.white),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked.toIso8601String().split('T').first;
      });
    }
  }

  Widget _buildGenderField() {
    return GestureDetector(
      onTap: () => _selectGender(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gender', style: labelStyle),
          const SizedBox(height: 10),
          Container(
            padding: fieldPadding,
            decoration: fieldDecoration,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedGender == null ? 'select' : '$selectedGender',
                    style: valueStyle,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectGender(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.profileSecondaryColor,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Gender',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Male', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, 'Male'),
            ),
            ListTile(
              title: const Text(
                'Female',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context, 'Female'),
            ),
            ListTile(
              title: const Text('Other', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, 'Other'),
            ),
          ],
        ),
      ),
    );
    if (result != null) {
      setState(() {
        selectedGender = result;
      });
    }
  }

  String _formatDate(DateTime? dob) {
    if (dob == null) return 'select';
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${dob.day} ${months[dob.month - 1]} ${dob.year}';
  }

  void _showEditConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.profilePrimaryColor,
          title: const Text(
            'Confirm Edit',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to edit your profile?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final userData = await SecureStorageService()
                      .readCredentials();
                  final updateData = UpdateProfile(
                    id: userData.userId ?? '',
                    userName: nameController.text,
                    dateOfBirth: selectedDate,
                    gender: selectedGender,
                  );

                  final result = await ref
                      .read(profileProvider)
                      .updateProfile(updateData);

                  if (result['status'] == 'success') {
                    // Refresh the user data
                    ref.invalidate(currentUserDataProvider);
                    _showSnackBar(result['message'], Colors.green);
                  } else {
                    _showSnackBar(result['message'], Colors.red);
                  }

                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}
