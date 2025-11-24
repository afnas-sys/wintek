import 'package:flutter/material.dart';
import 'package:wintek/features/game/spin_to_win/widgets/slot.dart';
import 'package:wintek/features/game/spin_to_win/widgets/spin_bet_button.dart';
import 'package:wintek/features/game/widgets/wallet_container.dart';

class SpinToWinScreen extends StatelessWidget {
  const SpinToWinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              children: [
                WalletContainer(),
                SlotGameOneDirection(),
                SpinBetButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
