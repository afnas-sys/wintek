import 'package:flutter/material.dart';
import 'package:wintek/utils/constants/app_colors.dart';

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
