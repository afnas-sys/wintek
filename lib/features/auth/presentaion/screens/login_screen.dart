import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/features/auth/domain/model/login_model.dart';
import 'package:wintek/features/auth/presentaion/screens/otp_varification_screen.dart';
import 'package:wintek/features/auth/presentaion/widgets/custom_appbar.dart';
import 'package:wintek/features/auth/presentaion/widgets/custom_snackbar.dart';
import 'package:wintek/features/auth/providers/auth_notifier.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/auth/providers/google_auth_notifier.dart';
import 'package:wintek/features/auth/services/google_auth_services.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/utils/validators.dart';
import 'package:wintek/core/router/routes_names.dart';
import 'package:wintek/core/widgets/custom_text_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isChecked = false;
  bool _isObscure = true;
  late final GoogleAuthService googleAuthService;
  @override
  void initState() {
    super.initState();
    _phoneController.clear();
    _passwordController.clear();
    googleAuthService = GoogleAuthService(ref.read(dioProvider));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(googleAuthProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    return authState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: CustomAppbar(
                showBackButton: false,
                title: 'Log in',
                subtitle:
                    'Please log in with your phone number\nIf you forget your password, contact costomer service',
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

                          _textWidget(text: 'Phone Number'),

                          SizedBox(height: 10),

                          //! field for Phone number
                          _phoneNumberfield(),

                          SizedBox(height: 20),

                          _textWidget(text: 'Password'),

                          SizedBox(height: 10),

                          _passwordField(),

                          SizedBox(height: 20),

                          //Remember pass and Forget pass
                          _rememberAndForgetPass(),

                          SizedBox(height: 30),

                          //Login Button
                          _loginButton(authNotifier),

                          SizedBox(height: 20),

                          //!Register
                          _registerButton(),

                          SizedBox(height: 40),

                          Column(
                            spacing: 10,
                            children: [
                              Text(
                                'or login with',
                                style: Theme.of(
                                  context,
                                ).textTheme.authBodyMediumThird,
                              ),

                              //! Google field
                              _googleButton(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  //! Text
  Widget _textWidget({required String text}) {
    return Text(text, style: Theme.of(context).textTheme.authBodyMediumPrimary);
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
          Text("+91", style: Theme.of(context).textTheme.authBodyMediumThird),
          const SizedBox(width: 4),
          Icon(
            FontAwesomeIcons.angleDown,
            color:
                // vasil changed color
                AppColors.authFifthColor,
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

  //! field for password
  Widget _passwordField() {
    return CustomTextFormField(
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
          color: AppColors.authFifthColor,
          size: 20,
        ),
      ),
      validator: Validators.validatePassword,
      autoValidate: true,
    );
  }

  //! Remember and Forget password
  Widget _rememberAndForgetPass() {
    return Row(
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
            activeColor: AppColors.authTertiaryColor, // color when checked
            checkColor: AppColors.authSixthColor, // checkmark color
          ),
        ),
        SizedBox(width: 4),
        Text(
          "Remember Password",

          style: Theme.of(context).textTheme.authBodyMediumThird,
        ),
        Spacer(),

        //Forget password button
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, RoutesNames.forgot);
          },
          child: Text(
            "Forget Password",
            style: Theme.of(context).textTheme.authBodyMediumSecondary,
          ),
        ),
      ],
    );
  }

  //! Login button
  Widget _loginButton(AuthNotifier authNotifier) {
    return CustomElevatedButton(
      onPressed: () async {
        if (_formkey.currentState!.validate()) {
          final res = await authNotifier.login(
            LoginRequestModel(
              mobile: _phoneController.text.trim(),
              password: _passwordController.text.trim(),
            ),
            context,
          );
          log('res is ${res?.data.verified}');
          if (res != null && res.data.verified == false) {
            ref.read(userDraftProvider.notifier).state = {
              'mobile': _phoneController.text.trim(),
            };
            log(
              'Mobile number is ${ref.read(userDraftProvider.notifier).state}',
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OtpVarificationScreen()),
            );
            return;
          }
          // Show snackbar with the message

          if (res?.message == 'Login Successfully') {
            CustomSnackbar.show(
              context,
              message: res?.message ?? 'Login Error',
              backgroundColor: AppColors.snackbarSuccessValidateColor,
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesNames.bottombar,
              (route) => false,
            );
          }
        }
      },

      backgroundColor: AppColors.authTertiaryColor,
      borderRadius: 30,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 14),
      width: double.infinity,
      child: Text(
        'Log in',
        style: Theme.of(context).textTheme.authBodyLargeTertiary,
      ),
    );
  }

  //! Register button
  Widget _registerButton() {
    return CustomElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, RoutesNames.registerScreen);
      },
      backgroundColor: Colors.transparent,
      borderRadius: 30,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderColor: AppColors.authTertiaryColor,
      width: double.infinity,
      child: Text(
        'Register',
        style: Theme.of(context).textTheme.authBodyLargeFourth,
      ),
    );
  }

  //! Google Button
  Widget _googleButton() {
    return CustomElevatedButton(
      onPressed: () async {
        final Map<bool, String> res = await ref
            .read(googleAuthProvider.notifier)
            .googleSignIn();
        if (res.keys.first == true) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesNames.bottombar,
            (route) => false,
          );
        }
        CustomSnackbar.show(
          backgroundColor: res.keys.first == true
              ? AppColors.snackbarSuccessValidateColor
              : AppColors.snackbarValidateColor,
          context,
          message: res.values.first,
        );
      },
      borderColor: AppColors.borderAuthTextField,
      padding: EdgeInsets.symmetric(vertical: 16),
      borderRadius: 30,
      backgroundColor: Colors.transparent,
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImages.googleIcon),
          Text(
            'Login with Google',
            style: Theme.of(context).textTheme.authBodyLargeSecondary,
          ),
        ],
      ),
    );
  }
}
