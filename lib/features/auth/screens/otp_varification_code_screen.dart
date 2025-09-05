import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wintek/features/auth/widgets/custom_appbar.dart';
import 'package:wintek/utils/constants/app_colors.dart';
import 'package:wintek/utils/constants/theme.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';

class OtpVarificationCodeScreen extends StatefulWidget {
  const OtpVarificationCodeScreen({super.key});

  @override
  State<OtpVarificationCodeScreen> createState() =>
      _OtpVarificationCodeScreenState();
}

class _OtpVarificationCodeScreenState extends State<OtpVarificationCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());
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

  String getOtp() {
    return _controllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 30),
                Text(
                  'Full Name',
                  style: Theme.of(context).textTheme.authBodyLargeSecondary,
                ),
                SizedBox(height: 10),
                //! OTP Field
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(5, (index) {
                    return SizedBox(
                      width: 71.2,
                      height: 66,
                      child: TextFormField(
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
                              // ✅ All digits entered
                              debugPrint("OTP: ${getOtp()}");
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

                SizedBox(height: 40),
                CustomElevatedButton(
                  onPressed: () {},
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

                SizedBox(height: 38),

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
                        minimumSize: Size(0, 0),
                      ),
                      onPressed: () {
                        // TODO
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
