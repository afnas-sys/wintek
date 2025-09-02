import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wintek/features/game/card_jackpot/domain/game_round/round_model.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/utils/app_colors.dart';
import 'package:wintek/utils/app_images.dart';

class MyHistoryTile extends ConsumerWidget {
  final BetModel bet;

  const MyHistoryTile({super.key, required this.bet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String dateTime = DateFormat('yyyy-MM-dd hh:mm a').format(bet.betTime!);
    final getCardName = bet.cardName.toString();
    final cardName = getCardName == '10' ? '10' : getCardName[0];
    return ListTile(
      leading: Row(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(child: Image.asset(AppImages.kingImage, fit: BoxFit.fill)),
          AppText(text: cardName, fontSize: 14, fontWeight: FontWeight.w400),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: VerticalDivider(thickness: 0.6),
          ),
        ],
      ),
      title: AppText(text: bet.id, fontSize: 16, fontWeight: FontWeight.w400),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          AppText(
            text: dateTime,
            fontSize: 12,
            color: AppColors.cardUnfocusedColor,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            fontSize: 12,
            text: bet.status,
            fontWeight: FontWeight.w400,
            color: bet.status == 'pending'
                ? AppColors.pendingStatusColor
                : bet.status == 'success'
                ? AppColors.successTextColor
                : AppColors.failedTextColor,
          ),
          if (bet.status != 'pending')
            AppText(
              text: "+₹${bet.amount}",
              fontWeight: FontWeight.w500,
              color: bet.status == 'success'
                  ? AppColors.successTextColor
                  : AppColors.failedTextColor,
              fontSize: 16,
            ),
        ],
      ),
    );
  }
}
