import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/card_numbers.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/main_cards.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/features/game/card_jackpot/providers/card_game_notifier.dart';
import 'package:wintek/features/game/card_jackpot/providers/time/time_provider.dart';
import 'package:wintek/core/constants/app_colors.dart';

class CardsSection extends ConsumerWidget {
  final int selectedCardTypeIndex;

  const CardsSection({super.key, required this.selectedCardTypeIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = ref.watch(cardRoundNotifierProvider);
    final timer = ref.watch(timerProvider);

    String overlayText;
    double fontSize = 130;

    if (round == null) {
      // 1️⃣ Initial load
      overlayText = 'Loading...';
      fontSize = 50;
    } else if (round.state == 'PREPARE') {
      // 2️⃣ Preparing
      overlayText = 'Preparing';
      fontSize = 50;
    } else if (round.state == 'RUNNING') {
      // 2️⃣ Running
      overlayText = timer.inSeconds.toString();
      fontSize = 130;
    } else if (round.state == 'ENDED') {
      // 3️⃣ Ended
      overlayText = 'END';
      fontSize = 50;
    } else {
      // Fallback for unknown states
      overlayText = 'Loading...';
      fontSize = 50;
    }

    // Show overlay if not running OR if still loading
    final showOverlay = round == null || round.state != 'RUNNING';

    return SizedBox(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              MainCards(selectedCardTypeIndex: selectedCardTypeIndex),
              const SizedBox(height: 10),
              NumbersCards(selectedCardTypeIndex: selectedCardTypeIndex),
            ],
          ),
          if (showOverlay && overlayText.isNotEmpty)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.cardUnfocusedColor,
                    width: 6,
                  ),
                ),
                child: Center(
                  child: AppText(
                    text: overlayText,
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
