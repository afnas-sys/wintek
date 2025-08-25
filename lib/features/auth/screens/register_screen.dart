import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wintek/features/auth/widgets/custom_appbar.dart';
import 'package:wintek/utils/theme.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';
import 'package:wintek/features/auth/widgets/custom_snackbar.dart';
import 'package:wintek/utils/widgets/custom_text_form_field.dart';
import 'package:wintek/utils/app_colors.dart';
import 'package:wintek/utils/router/routes_names.dart';
import 'package:wintek/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
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
                  SizedBox(height: 14),
                  Text(
                    'Phone Number',
                    style: Theme.of(context).textTheme.bodyMediumPrimary,
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
                          color: AppColors.textformfieldPrimaryIconColor,
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
                    'Set Password',
                    //!BODY SMALL
                    style: Theme.of(context).textTheme.bodyMediumPrimary,
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
                        color: AppColors.textformfieldPrimaryIconColor,
                        size: 20,
                      ),
                    ),
                    validator: Validators.validatePassword,
                    autoValidate: true,
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Confirm Password',
                    style: Theme.of(context).textTheme.bodyMediumPrimary,
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
                        color: AppColors.textformfieldPrimaryIconColor,
                        size: 20,
                      ),
                    ),
                    validator: Validators.validatePassword,
                    autoValidate: true,
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Invite code',
                    style: Theme.of(context).textTheme.bodyMediumPrimary,
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
                          activeColor: AppColors
                              .checkboxActiveColor, // color when checked
                          checkColor:
                              AppColors.checkboxColor, // checkmark color
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "I have Read and Agree[Privacy Agreement]",
                        style: Theme.of(context).textTheme.bodyMediumSecondary,
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
                  //Button for Register
                  CustomElevatedButton(
                    text: 'Register',
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
                    backgroundColor: AppColors.bgPrimaryColor,
                    borderRadius: 30,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 14,
                      bottom: 14,
                    ),
                    width: double.infinity,
                    textColor: AppColors.buttonPrimaryTextColor,
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
                    backgroundColor: AppColors.bgSecondaryColor,
                    borderRadius: 30,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 14,
                      bottom: 14,
                    ),
                    width: double.infinity,
                    textColor: AppColors.buttonSecondaryTextColor,
                    child: Text.rich(
                      TextSpan(
                        text: 'I have an Account ',
                        style: GoogleFonts.roboto(
                          color: AppColors.bgThirdColor,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Log in',
                            style: GoogleFonts.roboto(
                              color: AppColors.buttonSecondaryTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
