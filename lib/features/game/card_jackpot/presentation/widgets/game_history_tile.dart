import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';

class GameHistoryTile extends StatelessWidget {
  final String period;
  final String result;
  const GameHistoryTile({
    super.key,
    required this.period,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    // Parse card result and get suit image
    String suitImage = _getSuitImage(result);
    String displayValue = _getDisplayValue(result);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: AppText(text: period, fontSize: 14, fontWeight: FontWeight.w600),
        trailing: SizedBox(
          width: 50,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              if (suitImage.isNotEmpty)
                Image.asset(
                  suitImage,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              const SizedBox(width: 18),
              Expanded(
                child: AppText(
                  text: displayValue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSuitImage(String cardResult) {
    if (cardResult.contains('-')) {
      List<String> parts = cardResult.split('-');
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

  String _getDisplayValue(String cardResult) {
    if (cardResult.contains('-')) {
      List<String> parts = cardResult.split('-');
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
    return cardResult;
  }
}
