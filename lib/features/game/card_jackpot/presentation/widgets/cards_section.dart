import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/card_numbers.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/main_cards.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/features/game/card_jackpot/providers/round_provider.dart';
import 'package:wintek/features/game/card_jackpot/providers/time_provider.dart';
import 'package:wintek/core/constants/app_colors.dart';

class CardsSection extends ConsumerWidget {
  final int selectedCardTypeIndex;

  const CardsSection({super.key, required this.selectedCardTypeIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = ref.watch(cardRoundNotifierProvider);
    final timer = ref.watch(timerProvider);

    // Determine overlay text and font size based on round state
    final overlayData = _getOverlayData(round, timer);
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
          if (showOverlay && overlayData.text.isNotEmpty)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.cardUnfocusedColor,
                    width: 6,
                  ),
                ),
                child: Center(
                  child: AppText(
                    text: overlayData.text,
                    color: Colors.white,
                    fontSize: overlayData.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  ({String text, double fontSize}) _getOverlayData(
    dynamic round,
    Duration timer,
  ) {
    if (round == null) return (text: 'null', fontSize: 50.0);
    switch (round.state) {
      case 'PREPARE':
        return (text: timer.inSeconds.toString(), fontSize: 130.0);
      case 'RUNNING':
        return (text: timer.inSeconds.toString(), fontSize: 130.0);
      case 'ENDED':
        return (text: 'ENDED', fontSize: 50.0);
      default:
        return (text: 'loading..', fontSize: 50.0);
    }
  }
}
