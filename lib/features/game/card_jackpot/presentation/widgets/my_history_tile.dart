import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';

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

    // Parse card number and get suit image
    String cardNumber = bet['cardNumber'] ?? 'N/A';
    String suitImage = _getSuitImage(cardNumber);
    String displayValue = _getDisplayValue(cardNumber);

    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      child: ListTile(
        leading: SizedBox(
          width: 70,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (suitImage.isNotEmpty)
                Image.asset(
                  suitImage,
                  width: 18,
                  height: 18,
                  fit: BoxFit.contain,
                ),
              const SizedBox(width: 10),
              Expanded(
                child: AppText(
                  text: displayValue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: VerticalDivider(thickness: 0.6),
              ),
            ],
          ),
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
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                text: bet['status'] == 'placed'
                    ? 'Pending'
                    : bet['status'] == 'lost'
                    ? 'failed'
                    : 'Win',
                fontWeight: FontWeight.w500,
                color: bet['status'] == 'placed'
                    ? AppColors.pendingStatusColor
                    : bet['status'] != 'lost'
                    ? AppColors.successTextColor
                    : AppColors.failedTextColor,
              ),
              SizedBox(height: 5),
              if (bet['status'] != 'placed')
                AppText(
                  text: bet['status'] == 'lost'
                      ? "-₹${bet['points']}"
                      : "+₹${bet['winningAmount']}",
                  fontWeight: FontWeight.w500,
                  color: bet['status'] == 'lost'
                      ? AppColors.failedTextColor
                      : AppColors.successTextColor,
                  fontSize: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSuitImage(String cardNumber) {
    if (cardNumber.contains('-')) {
      List<String> parts = cardNumber.split('-');
      if (parts.length >= 2) {
        String suit = parts[0].toLowerCase();
        switch (suit) {
          case 'club':
            return AppImages.clubsImage;
          case 'spade':
            return AppImages.spadesImage;
          case 'heart':
            return AppImages.heartImage;
          case 'diamond':
            return AppImages.diamondImage;
          default:
            return '';
        }
      }
    }
    return '';
  }

  String _getDisplayValue(String cardNumber) {
    if (cardNumber.contains('-')) {
      List<String> parts = cardNumber.split('-');
      if (parts.length >= 2) {
        String value = parts[1];
        // Use single letter abbreviations for face cards
        switch (value.toLowerCase()) {
          case 'jack':
            return 'J';
          case 'queen':
            return 'Q';
          case 'king':
            return 'K';
          case 'ace':
            return 'A';
          default:
            return value; // Keep numbers as they are
        }
      }
    }
    return cardNumber;
  }
}
