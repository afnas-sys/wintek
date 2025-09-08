import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:wintek/features/auth/presentaion/widgets/custom_appbar.dart';
import 'package:wintek/features/auth/presentaion/widgets/custom_snackbar.dart';
import 'package:wintek/features/auth/providers/mobile_provider.dart';
import 'package:wintek/utils/router/routes_names.dart';
import 'package:wintek/utils/widgets/custom_text_form_field.dart';
import 'package:wintek/utils/constants/theme.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';
import 'package:wintek/utils/constants/app_colors.dart';
import 'package:wintek/utils/constants/validators.dart';

// Import your Auth Notifier
import 'package:wintek/features/auth/services/auth_notifier.dart';

class RegisterPhoneScreen extends ConsumerStatefulWidget {
  const RegisterPhoneScreen({super.key});

  @override
  ConsumerState<RegisterPhoneScreen> createState() =>
      _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends ConsumerState<RegisterPhoneScreen> {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _setPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _inviteCodeController = TextEditingController();

  bool _isObscure = true;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Register',
        subtitle: 'Please register by phone number or email',
        height: 200,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  /// Top buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {},
                          backgroundColor: AppColors.authTertiaryColor,
                          borderRadius: 30,
                          borderColor: AppColors.authTertiaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          child: Text(
                            'Log in with Phone',
                            style: Theme.of(
                              context,
                            ).textTheme.authBodyLargeTertiary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RoutesNames.registeremail,
                            );
                          },
                          backgroundColor: AppColors.authPrimaryColor,
                          borderRadius: 30,
                          borderColor: AppColors.authTertiaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 14,
                          ),
                          child: Text(
                            'Email Login',
                            style: Theme.of(
                              context,
                            ).textTheme.authBodyLargeFourth,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// Full Name
                  Text(
                    'Full Name',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _nameController,
                    hintText: "Enter full name",
                    keyboardType: TextInputType.name,
                    validator: Validators.validateFullName,
                    autoValidate: true,
                  ),

                  const SizedBox(height: 20),

                  /// Phone Number
                  Text(
                    'Phone Number',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _phoneController,
                    hintText: "Enter mobile number",
                    keyboardType: TextInputType.number,
                    prefix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 12),
                        const Text(
                          "+91",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textformfieldPrimaryTextColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          FontAwesomeIcons.angleDown,
                          size: 16,
                          color: AppColors.authFourthColor,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "|",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textformfieldPrimaryTextColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    validator: Validators.validatePhone,
                    autoValidate: true,
                  ),

                  const SizedBox(height: 20),

                  /// Set Password
                  Text(
                    'Set Password',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _setPassController,
                    hintText: "Set Password",
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscure,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() => _isObscure = !_isObscure);
                      },
                      icon: Icon(
                        _isObscure
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
                        color: AppColors.authFourthColor,
                        size: 20,
                      ),
                    ),
                    validator: Validators.validatePassword,
                    autoValidate: true,
                  ),

                  const SizedBox(height: 20),

                  /// Confirm Password
                  Text(
                    'Confirm Password',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _confirmPassController,
                    hintText: "Confirm Password",
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscure,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() => _isObscure = !_isObscure);
                      },
                      icon: Icon(
                        _isObscure
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
                        color: AppColors.authFourthColor,
                        size: 20,
                      ),
                    ),
                    validator: Validators.validatePassword,
                    autoValidate: true,
                  ),

                  const SizedBox(height: 20),

                  /// Invite Code
                  Text(
                    'Invite code',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _inviteCodeController,
                    hintText: 'Invite code',
                  ),

                  const SizedBox(height: 20),

                  /// Checkbox
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          shape: const CircleBorder(),
                          value: _isChecked,
                          onChanged: (val) => setState(() => _isChecked = val!),
                          activeColor: AppColors.authTertiaryColor,
                          checkColor: AppColors.authSixthColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "I have Read and Agree[Privacy Agreement]",
                        style: Theme.of(
                          context,
                        ).textTheme.authBodyMediumPrimary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// Register button
                  CustomElevatedButton(
                    onPressed: authState.isLoading
                        ? null
                        : () async {
                            if (!_isChecked) {
                              CustomSnackbar.show(
                                context,
                                message: 'Please accept terms and conditions',
                              );
                              return;
                            }
                            if (_formkey.currentState!.validate()) {
                              log('Register API call');

                              await ref
                                  .read(authNotifierProvider.notifier)
                                  .registerWithMobile(
                                    name: _nameController.text,
                                    mobile: _phoneController.text,
                                    password: _setPassController.text,
                                    referralCode: _inviteCodeController.text,
                                  );

                              // Save mobile in provider for OTP screen
                              ref.read(mobileNumberProvider.notifier).state =
                                  _phoneController.text;

                              // Navigate to OTP screen
                              Navigator.pushNamed(context, RoutesNames.otp);

                              final updatedState = ref.read(
                                authNotifierProvider,
                              );
                              if (updatedState.message != null) {
                                CustomSnackbar.show(
                                  context,
                                  message: updatedState.message!,
                                );
                              }
                            }
                          },
                    backgroundColor: AppColors.authTertiaryColor,
                    borderRadius: 30,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    width: double.infinity,
                    child: authState.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Register',
                            style: Theme.of(
                              context,
                            ).textTheme.authBodyLargeTertiary,
                          ),
                  ),

                  const SizedBox(height: 20),

                  /// Login button
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesNames.loginWithPhone,
                        (_) => false,
                      );
                    },
                    backgroundColor: AppColors.authPrimaryColor,
                    borderRadius: 30,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    width: double.infinity,
                    borderColor: AppColors.authTertiaryColor,
                    child: Text.rich(
                      TextSpan(
                        text: 'I have an Account ',
                        style: Theme.of(context).textTheme.authBodyLargePrimary,
                        children: [
                          TextSpan(
                            text: 'Log in',
                            style: Theme.of(
                              context,
                            ).textTheme.authBodyLargeFourth,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
