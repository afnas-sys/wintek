import 'package:flutter/material.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/game_section.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/wallet_container.dart';

// A widget that displays a stack of foreground elements including a wallet container and game tabs.

class ForegroundStack extends StatelessWidget {
  const ForegroundStack({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Responsive padding based on screen width
    EdgeInsets padding = screenWidth < 400
        ? const EdgeInsets.only(right: 10, left: 10, top: 40)
        : const EdgeInsets.only(right: 20, left: 20, top: 70);
    return Padding(
      padding: padding,
      child: Column(
        spacing: 10,
        children: [
          // Wallet Container section
          WalletContainer(),

          // GameSection(),
          GameTabs(),
        ],
      ),
    );
  }
}
