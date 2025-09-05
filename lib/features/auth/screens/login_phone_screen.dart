import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/features/auth/widgets/custom_appbar.dart';
import 'package:wintek/utils/constants/theme.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';
import 'package:wintek/utils/widgets/custom_text_form_field.dart';
import 'package:wintek/utils/constants/app_colors.dart';
import 'package:wintek/utils/router/routes_names.dart';
import 'package:wintek/utils/constants/validators.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isChecked = false;
  bool _isObscure = true;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        showBackButton: false,
        title: 'Log in',
        subtitle:
            'Please log in with your phone number or email\nIf you forget your password, contact support',
        height: 224,
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
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {},
                          backgroundColor: AppColors.authTertiaryColor,
                          borderRadius: 30,
                          borderColor: AppColors.authTertiaryColor,
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 14,
                            bottom: 14,
                          ),
                          child: Text(
                            'Log in with Phone',
                            style: Theme.of(
                              context,
                            ).textTheme.authBodyLargeTertiary,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RoutesNames.loginWithEmail,
                            );
                          },
                          backgroundColor: AppColors.authPrimaryColor,
                          borderRadius: 30,
                          borderColor: AppColors.authTertiaryColor,
                          padding: const EdgeInsets.only(
                            left: 30,
                            right: 30,
                            top: 14,
                            bottom: 14,
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
                  SizedBox(height: 30),
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
                    'Password',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  //   style: Theme.of(context).textTheme.bodySmall),
                  SizedBox(height: 10),

                  //field for Password
                  CustomTextFormField(
                    controller: _passwordController,

                    hintText: "Enter Password",
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

                  //Remember pass and Forget pass
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          shape: CircleBorder(),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                          activeColor:
                              AppColors.authTertiaryColor, // color when checked
                          checkColor:
                              AppColors.authSixthColor, // checkmark color
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Remember Password",

                        style: Theme.of(
                          context,
                        ).textTheme.authBodyMediumPrimary,
                      ),
                      Spacer(),

                      //Forget password button
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesNames.forgot);
                        },
                        child: Text(
                          "Forget Password",
                          style: Theme.of(
                            context,
                          ).textTheme.authBodyMediumSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  //Login Button
                  CustomElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        log('Login successful');
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesNames.aviatorGame,
                          (route) => false,
                        );
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
                    child: Text(
                      'Log in',
                      style: Theme.of(context).textTheme.authBodyLargeTertiary,
                    ),
                  ),
                  SizedBox(height: 20),

                  //Register
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesNames.registerphone);
                    },
                    backgroundColor: AppColors.authPrimaryColor,
                    borderRadius: 30,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 14,
                      bottom: 14,
                    ),
                    borderColor: AppColors.authTertiaryColor,
                    width: double.infinity,
                    child: Text(
                      'Register',
                      style: Theme.of(context).textTheme.authBodyLargeFourth,
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
