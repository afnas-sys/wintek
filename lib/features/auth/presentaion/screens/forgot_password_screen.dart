import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/features/auth/presentaion/widgets/custom_appbar.dart';
import 'package:wintek/features/auth/services/auth_notifier.dart';
import 'package:wintek/utils/constants/theme.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';
import 'package:wintek/features/auth/presentaion/widgets/custom_snackbar.dart';
import 'package:wintek/utils/widgets/custom_text_form_field.dart';
import 'package:wintek/utils/constants/app_colors.dart';
import 'package:wintek/utils/router/routes_names.dart';
import 'package:wintek/utils/constants/validators.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _setPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  bool _isObscure = true;
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: CustomAppbar(
        height: 224,
        title: 'Forgot Password',
        subtitle:
            'Please retrieve/change your password through your mobile phone number or email',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 14),
                  Text(
                    'Phone Number',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  SizedBox(height: 10),

                  //field for Phone number
                  CustomTextFormField(
                    controller: _phoneController,
                    hintText: "Enter mobile number",
                    keyboardType: TextInputType.number,
                    prefix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 12),
                        Text(
                          "+91",
                          style: TextStyle(
                            color: AppColors.textformfieldPrimaryTextColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          FontAwesomeIcons.angleDown,
                          color: AppColors.authFourthColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "|",
                          style: TextStyle(
                            color: AppColors.textformfieldPrimaryTextColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    validator: Validators.validatePhone,
                    autoValidate: true,
                  ),

                  SizedBox(height: 20),
                  Text(
                    'A New Password',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  SizedBox(height: 10),

                  //field for setting password
                  CustomTextFormField(
                    controller: _setPassController,
                    hintText: "Set Password",
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscure,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
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

                  SizedBox(height: 20),
                  Text(
                    'Confirm New Password',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  SizedBox(height: 10),
                  //field for Confirm Password
                  CustomTextFormField(
                    controller: _confirmPassController,
                    hintText: "Confirm Password",
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscure,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      icon: Icon(
                        _isObscure
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
                        color: AppColors.authFourthColor,
                        size: 20,
                      ),
                    ),
                    validator: (value) => Validators.validateConfirmPassword(
                      value,
                      _setPassController.text,
                    ),
                    autoValidate: true,
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Verification Code',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _verificationCodeController,
                    hintText: 'Please Enter Verification Code',
                    suffix: CustomElevatedButton(
                      borderRadius: 30,
                      padding: const EdgeInsets.only(
                        left: 30,
                        right: 30,
                        top: 10,
                        bottom: 10,
                      ),
                      onPressed: () {
                        ref
                            .read(authNotifierProvider.notifier)
                            .sendOtp(_phoneController.text);
                      },
                      backgroundColor: AppColors.authTertiaryColor,
                      child: Text(
                        'Send',
                        style: Theme.of(
                          context,
                        ).textTheme.authBodyLargeTertiary,
                      ),
                    ),
                    validator: Validators.validateVericationCode,
                    autoValidate: true,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          shape: CircleBorder(),
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                          activeColor:
                              AppColors.authTertiaryColor, // color when checked
                          checkColor:
                              AppColors.authSixthColor, // checkmark color
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "I have Read and Agree[Privacy Agreement]",
                        style: Theme.of(
                          context,
                        ).textTheme.authBodyMediumPrimary,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  //Button for Register
                  CustomElevatedButton(
                    onPressed: () async {
                      if (!_isChecked) {
                        CustomSnackbar.show(
                          context,
                          message: 'Please agree to the Privacy Agreement',
                        );
                        return;
                      }

                      if (_formKey.currentState!.validate()) {
                        final authNotifier = ref.read(
                          authNotifierProvider.notifier,
                        );

                        await authNotifier.forgottenPassword(
                          mobile: _phoneController.text,
                          password: _setPassController.text,
                          otp: _verificationCodeController.text,
                        );

                        final authState = ref.read(authNotifierProvider);

                        if (mounted && authState.message != null) {
                          CustomSnackbar.show(
                            context,
                            message: authState.message!,
                          );
                        }

                        if (mounted &&
                            authState.message?.toLowerCase().contains(
                                  "success",
                                ) ==
                                true) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesNames.loginWithPhone,
                            (route) => false,
                          );
                        }
                      }
                    },
                    backgroundColor: AppColors.authTertiaryColor,
                    borderRadius: 30,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 14,
                      bottom: 14,
                    ),
                    width: double.infinity,
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Reset',
                            style: Theme.of(
                              context,
                            ).textTheme.authBodyLargeTertiary,
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
