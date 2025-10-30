import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';

// 1. Background Stack Widget with two Containers
//  - Top Container: 35% of screen height, primary color - orange

// - Bottom Container: fills remaining space, second primary color - white

class BackgroundStack extends StatelessWidget {
  const BackgroundStack({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // Responsive height adjustment for top container based on screen height
    double topHeight;
    if (screenHeight < 700) {
      topHeight = screenHeight * 0.38;
    } else if (screenHeight < 900) {
      topHeight = screenHeight * 0.30;
    } else {
      topHeight = screenHeight * 0.28;
    }
    return Column(
      children: [
        Container(color: AppColors.cardPrimaryColor, height: topHeight),
        Container(color: AppColors.cardSecondPrimaryColor),
      ],
    );
  }
}
