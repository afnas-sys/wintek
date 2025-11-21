import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/domain/model/secure_storage_model.dart';

import 'package:wintek/features/auth/presentaion/widgets/custom_appbar.dart';
import 'package:wintek/features/auth/presentaion/widgets/custom_snackbar.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/router/routes_names.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';

// <-- make sure this path matches your project structure
import 'package:wintek/features/auth/providers/auth_notifier.dart';

class OtpVarificationScreen extends ConsumerStatefulWidget {
  const OtpVarificationScreen({super.key});

  @override
  ConsumerState<OtpVarificationScreen> createState() =>
      _OtpVarificationCodeScreenState();
}

class _OtpVarificationCodeScreenState
    extends ConsumerState<OtpVarificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  static const int _resendDelaySeconds = 120;
  int _remainingSeconds = 0;
  Timer? _countdownTimer;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _countdownTimer?.cancel();
    super.dispose();
  }

  String getOtp() => _controllers.map((c) => c.text).join();

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _remainingSeconds = _resendDelaySeconds;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() {
          _remainingSeconds = 0;
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final newUserData = ref.watch(userDraftProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppbar(
          title: 'OTP Verification',
          subtitle:
              'Enter the verification cide we just sent on your mobile number. (+91 ${newUserData?['mobile'] ?? ''})',
          height: 220,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Verify OTP',
                    style: Theme.of(context).textTheme.authBodyLargeSecondary,
                  ),
                  const SizedBox(height: 10),

                  //! OTP Field
                  _otpField(),

                  const SizedBox(height: 40),

                  //! Verify Button
                  _verifyButton(authState),

                  const SizedBox(height: 38),

                  //! Resend Button
                  _resendButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //! Otp Field
  Widget _otpField() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const fieldCount = 6;
        const spacing = 8.0;

        final totalSpacing = spacing * (fieldCount - 1);
        final maxWidthPerField =
            (constraints.maxWidth - totalSpacing) / fieldCount;
        final fieldWidth = maxWidthPerField.clamp(40.0, 60.0).toDouble();

        final List<Widget> children = [];

        for (var index = 0; index < fieldCount; index++) {
          children.add(
            SizedBox(
              width: fieldWidth,
              child: TextFormField(
                controller: _controllers[index],
                cursorColor: AppColors.textTertiaryColor,
                decoration: InputDecoration(
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: AppColors.borderAuthTextField,
                    ),
                  ),
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: AppColors.borderAuthTextField,
                    ),
                  ),
                ),
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.authTitleLarge,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    if (index < _focusNodes.length - 1) {
                      FocusScope.of(
                        context,
                      ).requestFocus(_focusNodes[index + 1]);
                    } else {
                      _focusNodes[index].unfocus();
                      debugPrint("OTP (complete): ${getOtp()}");
                    }
                  } else {
                    if (index > 0) {
                      FocusScope.of(
                        context,
                      ).requestFocus(_focusNodes[index - 1]);
                    }
                  }
                },
              ),
            ),
          );

          // Add spacing between fields, but not after the last one
          if (index != fieldCount - 1) {
            children.add(const SizedBox(width: spacing));
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        );
      },
    );
  }

  //! Verify Button
  Widget _verifyButton(AuthState authState) {
    return CustomElevatedButton(
      onPressed: () async {
        if (authState.isLoading) {
          return;
        }

        final otp = getOtp();

        if (otp.length != 6) {
          CustomSnackbar.show(
            backgroundColor: AppColors.snackbarValidateColor,
            context,
            message: 'Please enter the complete 6-digit OTP.',
          );
          return;
        }

        final bool result = await ref
            .read(authNotifierProvider.notifier)
            .verifyOtp(otp: otp);

        final res = ref.read(authNotifierProvider).message;
        debugPrint("✅ Verify response: $res");
        SecureStorageService storage = SecureStorageService();
        SecureStorageModel userCredential = await storage.readCredentials();
        if (result && userCredential.token != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesNames.bottombar,
            (route) => false,
          );
        }
        if (res != null) {
          CustomSnackbar.show(
            backgroundColor: AppColors.snackbarSuccessValidateColor,
            context,
            message: res,
          );
        }
      },
      backgroundColor: AppColors.authTertiaryColor,
      borderRadius: 30,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 14),
      width: double.infinity,
      child: Text(
        'Verify',
        style: Theme.of(context).textTheme.authBodyLargeTertiary,
      ),
    );
  }

  //! Resend Button
  Widget _resendButton() {
    return Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Didn\'t receive the code?',
          style: Theme.of(context).textTheme.authBodyMediumThird,
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          onPressed: _remainingSeconds > 0
              ? null
              : () {
                  _startCountdown();

                  debugPrint("🔄 Resend tapped");
                  ref
                      .read(authNotifierProvider.notifier)
                      .sendOtp(ref.read(userDraftProvider)!['mobile']);
                  CustomSnackbar.show(
                    backgroundColor: AppColors.snackbarSuccessValidateColor,
                    context,
                    message: 'OTP sent successfully',
                  );
                },
          child: Text(
            _remainingSeconds > 0 ? 'Resend in $_remainingSeconds s' : 'Resend',
            style: Theme.of(context).textTheme.authBodyLargeFourth,
          ),
        ),
      ],
    );
  }
}

class Debouncer {
  final int seconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.seconds});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(seconds: seconds), action);
  }
}
