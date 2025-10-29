import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/core/constants/app_colors.dart';

class MyHistoryTile extends StatelessWidget {
  final Map<String, dynamic> bet;

  const MyHistoryTile({super.key, required this.bet});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(bet['placedAt']);

    // Format to your desired format
    String formattedDate = DateFormat(
      'yyyy-MM-dd hh:mm a',
    ).format(dateTime.toLocal());
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: bet['cardNumber'] ?? 'N/A',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: VerticalDivider(thickness: 0.6),
          ),
        ],
      ),
      title: AppText(
        text: bet['sessionId'] ?? 'N/A',
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          AppText(
            text: formattedDate,
            fontSize: 12,
            color: AppColors.cardUnfocusedColor,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppText(
            text: bet['status'] ?? 'N/A',
            fontWeight: FontWeight.w500,
            color: bet['status'] == '-'
                ? AppColors.pendingStatusColor
                : bet['status'] != 'lost'
                ? AppColors.successTextColor
                : AppColors.failedTextColor,
          ),
          if (bet['status'] != '-')
            AppText(
              text: "+₹${bet['points']}",
              fontWeight: FontWeight.w500,
              color: bet['status'] != 'lost'
                  ? AppColors.successTextColor
                  : AppColors.failedTextColor,
              fontSize: 16,
            ),
        ],
      ),
    );
  }
}
