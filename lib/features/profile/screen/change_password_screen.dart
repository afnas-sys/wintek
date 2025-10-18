import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

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

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle password change logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
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
              _buildStatusBar(),
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

  Widget _buildStatusBar() {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          const Text(
            '9:41',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
            ),
          ),
          // Status icons
          Row(
            children: [
              // Signal bars
              Row(
                children: List.generate(
                  4,
                  (index) => Container(
                    margin: const EdgeInsets.only(right: 2),
                    width: 3,
                    height: 4 + (index * 2).toDouble(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // WiFi icon
              const Icon(Icons.wifi, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              // Battery
              SizedBox(
                width: 28,
                height: 13,
                child: Stack(
                  children: [
                    Container(
                      width: 25,
                      height: 13,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.35),
                        ),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 4,
                      child: Container(
                        width: 2,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 2,
                      top: 2,
                      child: Container(
                        width: 21,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
