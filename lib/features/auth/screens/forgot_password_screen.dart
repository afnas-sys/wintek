import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/features/auth/widgets/custom_appbar.dart';
import 'package:wintek/utils/theme.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';
import 'package:wintek/features/auth/widgets/custom_snackbar.dart';
import 'package:wintek/features/auth/widgets/custom_text_form_field.dart';
import 'package:wintek/utils/app_colors.dart';
import 'package:wintek/utils/router/routes_names.dart';
import 'package:wintek/utils/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _setPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  bool _isObscure = true;
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
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
                    //!BODY SMALL
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
                    'A New Password',
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
                    'Confirm New Password',
                    //!BODY SMALL
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
                    'Verification Code',
                    style: Theme.of(context).textTheme.bodyMediumPrimary,
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
                      textColor: AppColors.buttonPrimaryTextColor,
                      onPressed: () {},
                      text: 'Send',
                      backgroundColor: AppColors.bgPrimaryColor,
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
                          message: 'Please agree to the Privacy Agreement',
                        );
                        return;
                      }

                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesNames.loginWithPhone,
                          (route) => false,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
