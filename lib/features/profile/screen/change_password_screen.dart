import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/profile/provider/profile_notifier.dart';
import 'package:wintek/features/profile/services/profile_services.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  final String mobile;
  const ChangePasswordScreen({super.key, required this.mobile});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle password change logic here
      final data = ChangePasswordModel(
        mobileNumber: widget.mobile,
        oldPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      Color color = Colors.green;
      String? content;
      final Map<String, dynamic> res = await ref
          .read(profileProvider)
          .changePassword(data);
      if (res['status'] == 'success') {
        content = res['message'];
        Navigator.pop(context);
      } else if (res['status'] == 'failure') {
        content = res['message'];
        color = Colors.red;
      } else if (res['status'] == 'error') {
        content = res['message'] + ' Please try again';
        color = Colors.orange;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(content!), backgroundColor: color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140A2D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildHeader(context),
              const SizedBox(height: 50),
              _buildForm(),
            ],
          ),
        ),
      ),
    );
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
              width: 60,
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Title
          const Expanded(
            child: Text(
              'Change Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
          // Save button
          GestureDetector(
            onTap: _handleSave,
            child: Container(
              width: 60,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: const Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildPasswordField(
              label: 'Current Password',
              controller: _currentPasswordController,
              isVisible: _isCurrentPasswordVisible,
              onVisibilityToggle: () => setState(() {
                _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
              }),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your current password';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildPasswordField(
              label: 'New Password',
              controller: _newPasswordController,
              isVisible: _isNewPasswordVisible,
              onVisibilityToggle: () => setState(() {
                _isNewPasswordVisible = !_isNewPasswordVisible;
              }),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildPasswordField(
              label: 'Confirm Password',
              controller: _confirmPasswordController,
              isVisible: _isConfirmPasswordVisible,
              onVisibilityToggle: () => setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              }),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    required String? Function(String?) validator,
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFA395EE).withOpacity(0.2)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: !isVisible,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: '********',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                left: 24,
                right: 10,
                top: 18,
                bottom: 18,
              ),
              suffixIcon: GestureDetector(
                onTap: onVisibilityToggle,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  child: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white.withOpacity(0.5),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
