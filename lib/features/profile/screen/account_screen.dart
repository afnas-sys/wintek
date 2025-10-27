import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/features/profile/provider/profile_notifier.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String? selectedGender;

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
              selectedDate ?? 'date_of_birth';
              selectedGender ?? 'gender';
              return SingleChildScrollView(
                child: Column(
                  spacing: 40,
                  children: [
                    _buildHeader(context),
                    _buildProfileImage(data['picture']),
                    _buildForm(data),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(dialogBackgroundColor: Colors.transparent),
        child: child!,
      ),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectGender(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
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
          Container(
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
        ],
      ),
    );
  }

  Widget _buildProfileImage(String? profileImage) {
    final image = profileImage == "-" || profileImage == null
        ? 'https://api.builder.io/api/v1/image/assets/TEMP/2d9ca7e1c94e375f00e59a8525e451b4b93eaaa5'
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

  Widget _buildForm(Map<String, dynamic> userData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildFormField(
              label: 'Full Name',
              value: userData['user_name'] ?? 'Add name',
            ),
            const SizedBox(height: 20),
            _buildFormField(
              label: 'Email',
              value: userData['email'] ?? 'Add email',
            ),
            const SizedBox(height: 20),
            _buildFormField(
              label: 'Phone',
              value: userData['mobile'] ?? 'Add phone number',
            ),
            const SizedBox(height: 20),
            _buildFormField(
              label: 'Date of Birth',
              value: selectedDate != null
                  ? _formatDate(selectedDate)
                  : 'select',
              onTap: () => _selectDate(context),
              suffixIcon: Icon(Icons.date_range, color: Colors.white54),
            ),
            const SizedBox(height: 20),
            _buildGenderField(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
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

  Widget _buildFormField({
    required String label,
    required String value,
    Widget? suffixIcon,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFA395EE),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFA395EE).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.57,
                    ),
                  ),
                ),
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

  Widget _buildGenderField() {
    return GestureDetector(
      onTap: () => _selectGender(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gender',
            style: TextStyle(
              color: Color(0xFFA395EE),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFA395EE).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedGender ?? 'select',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.57,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
