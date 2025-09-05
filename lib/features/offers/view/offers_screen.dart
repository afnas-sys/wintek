import 'package:flutter/material.dart';
import 'package:wintek/utils/constants/app_colors.dart';
import 'package:wintek/utils/constants/app_images.dart';

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
