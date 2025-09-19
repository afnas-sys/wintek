import 'package:flutter/material.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/background_stack.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/foreground_stack.dart';
import 'package:wintek/core/constants/app_colors.dart';

class CardJackpotScreen extends StatelessWidget {
  const CardJackpotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardSecondPrimaryColor,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: [
              // Background and Foreground Stacks

              // 1. Background Stack
              BackgroundStack(),

              // 2. Foreground Stack
              ForegroundStack(),
            ],
          ),
        ),
      ),
    );
  }
}
