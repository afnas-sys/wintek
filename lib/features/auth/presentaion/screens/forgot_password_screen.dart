import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/features/auth/domain/model/forgot_password_model.dart';
import 'package:wintek/features/auth/presentaion/widgets/custom_appbar.dart';
import 'package:wintek/features/auth/providers/auth_notifier.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/auth/presentaion/widgets/custom_snackbar.dart';
import 'package:wintek/core/widgets/custom_text_form_field.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/router/routes_names.dart';
import 'package:wintek/core/utils/validators.dart';

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
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                    _textWidget(text: 'Phone Number'),

                    SizedBox(height: 10),

                    // field for Phone number
                    _phoneNumberfield(),

                    SizedBox(height: 20),
                    _textWidget(text: 'A New Password'),

                    SizedBox(height: 10),

                    //field for setting password
                    _passwordField(),

                    SizedBox(height: 20),

                    _textWidget(text: 'Confirm New Password'),

                    SizedBox(height: 10),

                    //field for Confirm Password
                    _confirmPasswordField(),

                    SizedBox(height: 20),

                    _textWidget(text: 'Verification Code'),

                    SizedBox(height: 10),

                    //field for verification code
                    _verificationCodeField(authNotifier),

                    SizedBox(height: 20),

                    // Privacy Policy
                    _privacyPolicy(),

                    SizedBox(height: 30),

                    //! Button for Reset
                    _resetButton(authNotifier),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //! Texts
  Widget _textWidget({required String text}) {
    return Text(
      text,
      style: Theme.of(context).textTheme.authBodyLargeSecondary,
    );
  }

  //! field for Phone number
  Widget _phoneNumberfield() {
    return CustomTextFormField(
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
    );
  }

  //! field for Password
  Widget _passwordField() {
    return CustomTextFormField(
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
          _isObscure ? Icons.remove_red_eye : Icons.visibility_off,
          color: AppColors.authFourthColor,
          size: 20,
        ),
      ),
      validator: Validators.validatePassword,
      autoValidate: true,
    );
  }

  //! Confirm Password
  Widget _confirmPasswordField() {
    return CustomTextFormField(
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
          _isObscure ? Icons.remove_red_eye : Icons.visibility_off,
          color: AppColors.authFourthColor,
          size: 20,
        ),
      ),
      validator: (value) =>
          Validators.validateConfirmPassword(value, _setPassController.text),
      autoValidate: true,
    );
  }

  //! verification code
  Widget _verificationCodeField(AuthNotifier authNotifier) {
    return CustomTextFormField(
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
        onPressed: () async {
          final msg = await authNotifier.sendOtp(_phoneController.text);

          CustomSnackbar.show(
            backgroundColor: AppColors.snackbarSuccessValidateColor,
            context,
            message: msg ?? 'Something went wrong',
          );
        },

        backgroundColor: AppColors.authTertiaryColor,
        child: Text(
          'Send',
          style: Theme.of(context).textTheme.authBodyLargeTertiary,
        ),
      ),
      validator: Validators.validateVericationCode,
      autoValidate: true,
    );
  }

  //! privacy policy
  Widget _privacyPolicy() {
    return Row(
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
            activeColor: AppColors.authTertiaryColor, // color when checked
            checkColor: AppColors.authSixthColor, // checkmark color
          ),
        ),
        SizedBox(width: 10),
        Text(
          "I have Read and Agree[Privacy Agreement]",
          style: Theme.of(context).textTheme.authBodyMediumPrimary,
        ),
      ],
    );
  }

  //! Reset
  Widget _resetButton(AuthNotifier authNotifier) {
    return CustomElevatedButton(
      onPressed: () async {
        if (!_isChecked) {
          CustomSnackbar.show(
            context,
            message: 'Please agree to the Privacy Agreement',
          );
          return;
        }

        if (_formKey.currentState!.validate()) {
          final result = await authNotifier.forgottenPassword(
            ForgotPasswordRequestModel(
              mobile: _phoneController.text,
              password: _setPassController.text,
              otp: _verificationCodeController.text,
            ),
          );

          final latestState = ref.read(authNotifierProvider);

          if (mounted && result == true) {
            CustomSnackbar.show(
              backgroundColor: AppColors.snackbarSuccessValidateColor,
              context,
              message: latestState.message ?? "Password changed successfully",
            );

            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesNames.loginScreen,
              (route) => false,
            );
          } else if (mounted && latestState.message != null) {
            CustomSnackbar.show(
              backgroundColor: AppColors.snackbarValidateColor,
              context,
              message: latestState.message!,
            );
          }
        }
      },

      backgroundColor: AppColors.authTertiaryColor,
      borderRadius: 30,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 14),
      width: double.infinity,
      child: Text(
        'Reset',
        style: Theme.of(context).textTheme.authBodyLargeTertiary,
      ),
    );
  }
}
