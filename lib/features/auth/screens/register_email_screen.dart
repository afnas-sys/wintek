import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/features/auth/widgets/custom_appbar.dart';
import 'package:wintek/utils/theme.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';
import 'package:wintek/features/auth/widgets/custom_snackbar.dart';
import 'package:wintek/utils/widgets/custom_text_form_field.dart';
import 'package:wintek/utils/app_colors.dart';
import 'package:wintek/utils/router/routes_names.dart';
import 'package:wintek/utils/validators.dart';

class RegisterEmailScreen extends StatefulWidget {
  const RegisterEmailScreen({super.key});

  @override
  State<RegisterEmailScreen> createState() => _RegisterEmailScreenState();
}

class _RegisterEmailScreenState extends State<RegisterEmailScreen> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final _nameController = TextEditingController();
  final _setPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _inviteCodeController = TextEditingController();

  bool _isObscure = true;
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RoutesNames.registerphone,
                              (route) => false,
                            );
                          },
                          backgroundColor: AppColors.authPrimaryColor,
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
                            ).textTheme.authBodyLargeFourth,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CustomElevatedButton(
                          //text: 'Email Login',
                          onPressed: () {},
                          backgroundColor: AppColors.authTertiaryColor,
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
                            ).textTheme.authBodyLargeTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Full Name',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  SizedBox(height: 10),

                  //field for Fll name
                  CustomTextFormField(
                    controller: _nameController,
                    hintText: "Enter full name",
                    keyboardType: TextInputType.name,
                    validator: Validators.validateFullName,
                    autoValidate: true,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Email ID',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  SizedBox(height: 10),

                  //field for Email
                  CustomTextFormField(
                    controller: _emailController,
                    hintText: "Enter email",
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    autoValidate: true,
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Set Password',
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
                    'Confirm Password',
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
                    validator: Validators.validatePassword,
                    autoValidate: true,
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Invite code',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _inviteCodeController,
                    hintText: 'Invite code',
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
                    onPressed: () {
                      if (!_isChecked) {
                        CustomSnackbar.show(
                          context,
                          message: 'Please accept terms and conditions',
                        );
                      }
                      if (_formkey.currentState!.validate()) {
                        log('message');
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesNames.loginWithPhone,
                          (_) => false,
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
                      'Register',
                      style: Theme.of(context).textTheme.authBodyLargeTertiary,
                    ),
                  ),

                  SizedBox(height: 20),

                  //Button for Login
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
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 14,
                      bottom: 14,
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
