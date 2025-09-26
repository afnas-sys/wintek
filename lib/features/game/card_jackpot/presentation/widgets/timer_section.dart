import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/features/game/card_jackpot/providers/card_game_notifier.dart';
import 'package:wintek/features/game/card_jackpot/providers/time/time_provider.dart';
import 'package:wintek/core/constants/app_colors.dart';

class TimerSection extends ConsumerWidget {
  const TimerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerProvider);
    ref.read(timerProvider.notifier).start();

    final currentBetId = ref.watch(currentBetIdProvider);
    final minute = timer.inMinutes.remainder(60).toString().padLeft(2, '0');
    final second = timer.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardPrimaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(text: 'How to play', fontSize: 12),
              SizedBox(height: 5),
              AppText(
                text: currentBetId,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Time Remaining'),
              SizedBox(height: 5),
              Row(
                spacing: 4,
                children: [
                  buildBox(minute[0]),
                  buildBox(minute[1]),
                  buildBox(':'),
                  buildBox(second[0]),
                  buildBox(second[1]),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget buildBox(String text) {
  return Container(
    width: 22,
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.timerContainerColor,
      borderRadius: BorderRadius.circular(7),
    ),
    child: Center(
      child: AppText(
        text: text,
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
