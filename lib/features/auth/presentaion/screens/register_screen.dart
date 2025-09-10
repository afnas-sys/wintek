import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/features/auth/domain/model/register_model.dart';

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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends ConsumerState<RegisterScreen> {
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
    final authProvider = ref.watch(authNotifierProvider);
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final draftProvider = ref.watch(userDraftProvider.notifier);

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Register',
        subtitle: 'Please register by phone number',
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
                  const SizedBox(height: 10),

                  /// Full Name
                  Text(
                    'Full Name',
                    style: Theme.of(context).textTheme.authBodyMediumPrimary,
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
                    style: Theme.of(context).textTheme.authBodyMediumPrimary,
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
                          style: TextStyle(fontSize: 14, color: Colors.white),
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
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
                    style: Theme.of(context).textTheme.authBodyMediumPrimary,
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
                    style: Theme.of(context).textTheme.authBodyMediumPrimary,
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
                    validator: (va) => Validators.validateConfirmPassword(
                      _setPassController.text,
                      _confirmPassController.text,
                    ),
                    autoValidate: true,
                  ),

                  const SizedBox(height: 20),

                  /// Invite Code
                  Text(
                    'Invite code',
                    style: Theme.of(context).textTheme.authBodyMediumPrimary,
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
                        style: Theme.of(context).textTheme.authBodyMediumThird,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// Register button
                  CustomElevatedButton(
                    onPressed: authProvider.isLoading
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

                              final data = RegisterRequestModel(
                                name: _nameController.text,
                                mobile: _phoneController.text,
                                password: _setPassController.text,
                                referralCode: _inviteCodeController.text,
                              );
                              final bool res = await authNotifier.registerUser(
                                data,
                              );

                              // After registerUser finishes, get the latest state
                              final latestState = ref.read(
                                authNotifierProvider,
                              );

                              if (res) {
                                Navigator.pushNamed(context, RoutesNames.otp);
                              } else if (latestState.message != null) {
                                CustomSnackbar.show(
                                  context,
                                  message: latestState.message!,
                                  backgroundColor: Colors.red,
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
                    child: authProvider.isLoading
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
                    backgroundColor: AppColors.authEighthColor,
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
                        style: Theme.of(
                          context,
                        ).textTheme.authBodyLargeSecondary,
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
