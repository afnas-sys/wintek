import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/features/auth/domain/model/register_model.dart';

import 'package:wintek/features/auth/presentaion/widgets/custom_appbar.dart';
import 'package:wintek/features/auth/presentaion/widgets/custom_snackbar.dart';
import 'package:wintek/core/router/routes_names.dart';
import 'package:wintek/core/widgets/custom_text_form_field.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/utils/validators.dart';

// Import your Auth Notifier
import 'package:wintek/features/auth/providers/auth_notifier.dart';

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
  void _clearFields() {
    _nameController.clear();
    _phoneController.clear();
    _setPassController.clear();
    _confirmPassController.clear();
    _inviteCodeController.clear();
  }

  @override
  void initState() {
    _clearFields();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _setPassController.dispose();
    _confirmPassController.dispose();
    _inviteCodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                    _textWidget(text: 'Full Name'),

                    const SizedBox(height: 10),

                    // field for Full name
                    _fullNameField(),

                    const SizedBox(height: 20),

                    /// Phone Number
                    _textWidget(text: 'Phone Number'),

                    const SizedBox(height: 10),

                    // field for Phone number
                    _phoneNumberfield(),

                    const SizedBox(height: 20),

                    /// Set Password
                    _textWidget(text: 'Set Password'),

                    const SizedBox(height: 10),

                    // field for Set Password
                    _setPasswordField(),

                    const SizedBox(height: 20),

                    /// Confirm Password
                    _textWidget(text: 'Confirm Password'),

                    const SizedBox(height: 10),

                    // field for Confirm Password
                    _confirmPasswordField(),

                    const SizedBox(height: 20),

                    /// Invite Code
                    _textWidget(text: 'Invite Code'),

                    const SizedBox(height: 10),

                    // field for Invite Code
                    _inviteCodeField(),

                    const SizedBox(height: 20),

                    /// Checkbox
                    _privacyPolicy(),

                    const SizedBox(height: 30),

                    /// Register button
                    _registerButton(authNotifier),

                    const SizedBox(height: 20),

                    /// Login button
                    _loginButton(),
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
    return Text(text, style: Theme.of(context).textTheme.authBodyMediumPrimary);
  }

  //! Full Name Field
  Widget _fullNameField() {
    return CustomTextFormField(
      controller: _nameController,
      hintText: "Enter full name",
      keyboardType: TextInputType.name,
      validator: Validators.validateFullName,
      autoValidate: true,
    );
  }

  //! Phone number
  Widget _phoneNumberfield() {
    return CustomTextFormField(
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
          const Text("|", style: TextStyle(fontSize: 16, color: Colors.white)),
          const SizedBox(width: 8),
        ],
      ),
      validator: Validators.validatePhone,
      autoValidate: true,
    );
  }

  //! Set Password
  Widget _setPasswordField() {
    return CustomTextFormField(
      controller: _setPassController,
      hintText: "Set Password",
      keyboardType: TextInputType.visiblePassword,
      obscureText: _isObscure,
      suffix: IconButton(
        onPressed: () {
          setState(() => _isObscure = !_isObscure);
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

  //! Confirm Pass
  Widget _confirmPasswordField() {
    return CustomTextFormField(
      controller: _confirmPassController,
      hintText: "Confirm Password",
      keyboardType: TextInputType.visiblePassword,
      obscureText: _isObscure,
      suffix: IconButton(
        onPressed: () {
          setState(() => _isObscure = !_isObscure);
        },
        icon: Icon(
          _isObscure ? Icons.remove_red_eye : Icons.visibility_off,
          color: AppColors.authFourthColor,
          size: 20,
        ),
      ),
      validator: (va) =>
          Validators.validateConfirmPassword(_setPassController.text, va ?? ""),

      autoValidate: true,
    );
  }

  //! Invite code
  Widget _inviteCodeField() {
    return CustomTextFormField(
      controller: _inviteCodeController,
      hintText: 'Invite code',
    );
  }

  //! Privacy policy
  Widget _privacyPolicy() {
    return Row(
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
    );
  }

  //! Register button
  Widget _registerButton(AuthNotifier authNotifier) {
    return CustomElevatedButton(
      onPressed: () async {
        if (!_isChecked) {
          CustomSnackbar.show(
            context,
            message: 'Please accept terms and conditions',
          );
          return;
        }
        if (_formkey.currentState!.validate()) {
          final data = RegisterRequestModel(
            name: _nameController.text,
            mobile: _phoneController.text,
            password: _setPassController.text,
            referralCode: _inviteCodeController.text,
          );
          final String? res = await authNotifier.registerUser(data);

          // After registerUser finishes, get the latest state
          final latestState = ref.read(authNotifierProvider);

          if (res == 'signup') {
            Navigator.pushNamed(context, RoutesNames.otp);
            CustomSnackbar.show(
              backgroundColor: AppColors.snackbarSuccessValidateColor,
              context,
              message: 'OTP sent successfully',
            );
          } else if (latestState.message != null) {
            CustomSnackbar.show(
              context,
              message: latestState.message!,
              backgroundColor: AppColors.snackbarValidateColor,
            );
          }
        }
      },
      backgroundColor: AppColors.authTertiaryColor,
      borderRadius: 30,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      width: double.infinity,
      child: Text(
        'Register',
        style: Theme.of(context).textTheme.authBodyLargeTertiary,
      ),
    );
  }

  //! Login Button
  Widget _loginButton() {
    return CustomElevatedButton(
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesNames.loginScreen,
          (_) => false,
        );
      },
      backgroundColor: AppColors.authEighthColor,
      borderRadius: 30,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      width: double.infinity,
      borderColor: AppColors.authTertiaryColor,
      child: Text.rich(
        TextSpan(
          text: 'I have an Account ',
          style: Theme.of(context).textTheme.authBodyLargeSecondary,
          children: [
            TextSpan(
              text: 'Log in',
              style: Theme.of(context).textTheme.authBodyLargeFourth,
            ),
          ],
        ),
      ),
    );
  }
}
