import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/card_numbers.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/main_cards.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/features/game/card_jackpot/providers/time/time_provider.dart';
import 'package:wintek/utils/constants/app_colors.dart';

class CardsSection extends ConsumerWidget {
  final int selectedCardTypeIndex;
  const CardsSection({super.key, required this.selectedCardTypeIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerProvider);

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

          // Show overlay only at last 5 seconds
          if (timer.inSeconds <= 5)
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
                    text: timer.inSeconds.toString(),
                    color: Colors.white,
                    fontSize: 130,
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
