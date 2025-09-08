import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wintek/features/auth/presentaion/widgets/custom_appbar.dart';
import 'package:wintek/utils/constants/app_colors.dart';
import 'package:wintek/utils/constants/theme.dart';
import 'package:wintek/utils/router/routes_names.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';

// <-- make sure this path matches your project structure
import 'package:wintek/features/auth/services/auth_notifier.dart';

class OtpVarificationCodeScreen extends ConsumerStatefulWidget {
  const OtpVarificationCodeScreen({super.key});

  @override
  ConsumerState<OtpVarificationCodeScreen> createState() =>
      _OtpVarificationCodeScreenState();
}

class _OtpVarificationCodeScreenState
    extends ConsumerState<OtpVarificationCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String getOtp() => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: CustomAppbar(
        title: 'OTP Verification',
        subtitle:
            'Enter the verification cide we just sent on your mobile number. (+91 0987654321)',
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
                  'Full Name',
                  style: Theme.of(context).textTheme.authBodyLargeSecondary,
                ),
                const SizedBox(height: 10),

                //! OTP Field (unchanged UI)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 60,
                      //   height: 66,
                      child: TextFormField(
                        controller:
                            _controllers[index], // 👈 also bind controllers
                        cursorColor: AppColors.textTertiaryColor,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.authSecondaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide.none,
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
                    );
                  }),
                ),

                const SizedBox(height: 40),

                //! Verify Button (logic only; UI unchanged)
                CustomElevatedButton(
                  onPressed: () async {
                    if (authState.isLoading) {
                      // don’t let user spam while loading
                      debugPrint('⏳ Verification already in progress…');
                      return;
                    }

                    final otp = getOtp();
                    debugPrint("Entered OTP: $otp");

                    if (otp.length != 6) {
                      debugPrint("❌ OTP incomplete (need 6 digits)");
                      return;
                    }

                    // Call the refactored method (OTP → then signup)
                    await ref
                        .read(authNotifierProvider.notifier)
                        .verifyOtpAndSignup(otp: otp);

                    final result = ref.read(authNotifierProvider).message;
                    debugPrint("✅ Verify response: $result");
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesNames.home,
                      (route) => false,
                    );
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
                    'Verify',
                    style: Theme.of(context).textTheme.authBodyLargeTertiary,
                  ),
                ),

                const SizedBox(height: 38),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Didn\'t receive the code?',
                      style: Theme.of(context).textTheme.authBodyLargePrimary,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                      onPressed: () {
                        debugPrint("🔄 Resend tapped");
                        ref
                            .read(authNotifierProvider.notifier)
                            .sendOtp(ref.read(userDraftProvider)!['mobile']);
                      },
                      child: Text(
                        'Resend',
                        style: Theme.of(context).textTheme.authBodyLargeFourth,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
