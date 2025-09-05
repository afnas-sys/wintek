import 'package:flutter/material.dart';
import 'package:wintek/utils/constants/app_colors.dart';
import 'package:wintek/utils/constants/app_images.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profilePrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.profileSecondaryColor,
                  ),
                  child: Text('data'),
                ),
                CustomElevatedButton(
                  width: double.infinity,
                  borderRadius: 30,
                  backgroundColor: Color(0XFFEB644C),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImages.logout, height: 24, width: 24),
                      SizedBox(width: 10),
                      Text('Logout'),
                    ],
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
