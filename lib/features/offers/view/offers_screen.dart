import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offersPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.welcomeBonus),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.welcomeBonus),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.welcomeBonus),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.welcomeBonus),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Flushbar(
                      messageText: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'You Have Crashed\nout!',
                                      style: TextStyle(
                                        color: AppColors.aviatorSixteenthColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\n2.56X',
                                      style: TextStyle(
                                        color: AppColors.aviatorTertiaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: AppColors.aviatorEighteenthColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  'Win INR\n500X',
                                  style: const TextStyle(
                                    color: AppColors.aviatorTertiaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      backgroundColor: Color(0XFF133206),
                      //      margin: const EdgeInsets.all(2.0),
                      borderWidth: 2,
                      borderColor: AppColors.aviatorEighteenthColor,
                      duration: const Duration(seconds: 10),
                      flushbarPosition: FlushbarPosition.TOP,
                      flushbarStyle: FlushbarStyle.FLOATING,
                      borderRadius: BorderRadius.circular(50),
                      animationDuration: const Duration(seconds: 1),
                      maxWidth: 300,
                    ).show(context);
                  },
                  child: Text('data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
