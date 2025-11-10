import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/game_section.dart';
import 'package:wintek/features/game/widget/wallet_container.dart';

// A widget that displays a stack of foreground elements including a wallet container and game tabs.

class ForegroundStack extends StatelessWidget {
  const ForegroundStack({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    EdgeInsets padding = screenWidth < 400
        ? const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
    double screenHeight = MediaQuery.of(context).size.height;

    double topHeight;
    if (screenHeight < 700) {
      topHeight = screenHeight * 0.28;
    } else if (screenHeight < 900) {
      topHeight = screenHeight * 0.32;
    } else if (screenHeight < 450) {
      topHeight = screenHeight * 0.20;
    } else {
      topHeight = screenHeight * 0.26;
    }
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(color: AppColors.cardPrimaryColor, height: topHeight),

          Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                WalletContainer(),
                SizedBox(height: 10),
                GameTabs(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
