import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:winket/features/auth/widgets/custom_appbar.dart';
import 'package:winket/utils/theme.dart';
import 'package:winket/utils/widgets/custom_elevated_button.dart';
import 'package:winket/features/auth/widgets/custom_text_form_field.dart';
import 'package:winket/utils/app_colors.dart';
import 'package:winket/utils/router/routes_names.dart';
import 'package:winket/utils/validators.dart';

class LoginEmailScreen extends StatefulWidget {
  const LoginEmailScreen({super.key});

  @override
  State<LoginEmailScreen> createState() => _LoginLoginEmailScreenScreenState();
}

class _LoginLoginEmailScreenScreenState extends State<LoginEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isChecked = false;
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          text: 'Log in with Phone',
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RoutesNames.loginWithPhone,
                              (route) => false,
                            );
                          },
                          backgroundColor: AppColors.bgSecondaryColor,
                          borderRadius: 30,
                          borderColor: AppColors.borderPrimaryColor,
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 14,
                            bottom: 14,
                          ),
                          textColor: AppColors.buttonSecondaryTextColor,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CustomElevatedButton(
                          text: 'Email Login',
                          onPressed: () {},
                          backgroundColor: AppColors.bgPrimaryColor,
                          borderRadius: 30,
                          borderColor: AppColors.borderPrimaryColor,
                          padding: const EdgeInsets.only(
                            left: 30,
                            right: 30,
                            top: 14,
                            bottom: 14,
                          ),
                          textColor: AppColors.buttonPrimaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text('Email', style: Theme.of(context).textTheme.bodyMediumPrimary),
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
                  Text('Password', style: Theme.of(context).textTheme.bodyMediumPrimary),
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
                        _isObscure ? Icons.remove_red_eye : Icons.visibility_off,
                        color: AppColors.textformfieldPrimaryIconColor,
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
                              AppColors.checkboxActiveColor, // color when checked
                          checkColor: AppColors.checkboxColor, // checkmark color
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Remember Password",
                        style: Theme.of(context).textTheme.bodyMediumSecondary,
                      ),
                      Spacer(),
              
                      //Forget password button
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesNames.forgot);
                        },
                        child: Text(
                          "Forget Password",
                          style: Theme.of(context).textTheme.bodyMediumTertiary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
              
                  //Login Button
                  CustomElevatedButton(
                    text: 'Log in',
                    onPressed: () {
                      if (_formKey.currentState!.validate()){
                        log('Logged in');
                      }
                    },
                    backgroundColor: AppColors.bgPrimaryColor,
                    borderRadius: 30,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 14,
                      bottom: 14,
                    ),
                    textColor: AppColors.buttonPrimaryTextColor,
                    width: double.infinity,
                  ),
                  SizedBox(height: 20),
                  //Register
                  CustomElevatedButton(
                    text: 'Register',
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesNames.register);
                    },
                    backgroundColor: AppColors.bgSecondaryColor,
                    borderRadius: 30,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 14,
                      bottom: 14,
                    ),
                    textColor: AppColors.buttonSecondaryTextColor,
                    width: double.infinity,
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
