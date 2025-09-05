import 'package:flutter/material.dart';
import 'package:wintek/utils/constants/app_colors.dart';

// 1. Background Stack Widget with two Containers
//  - Top Container: 35% of screen height, primary color - orange

// - Bottom Container: fills remaining space, second primary color - white

class BackgroundStack extends StatelessWidget {
  const BackgroundStack({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          color: AppColors.cardPrimaryColor,
          height: screenHeight * 0.33,
        ),
        Container(color: AppColors.cardSecondPrimaryColor),
      ],
    );
  }
}
