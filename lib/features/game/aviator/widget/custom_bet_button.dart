import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';

enum BetButtonState { bet, cancel, cashout }

class CustomBetButton extends StatelessWidget {
  final BetButtonState state;
  final VoidCallback onBet;
  final VoidCallback onCancel;
  final VoidCallback onCashout;

  final String? betLabel;
  final String? cancelLabel;
  final String? cashoutLabel;

  const CustomBetButton({
    super.key,
    required this.state,
    required this.onBet,
    required this.onCancel,
    required this.onCashout,
    this.betLabel,
    this.cancelLabel,
    this.cashoutLabel,
  });

  String _getLabel() {
    switch (state) {
      case BetButtonState.bet:
        return betLabel ?? "BET";
      case BetButtonState.cancel:
        return cancelLabel ?? "CANCEL";
      case BetButtonState.cashout:
        return cashoutLabel ?? "CASHOUT";
    }
  }

  Color _getColor() {
    switch (state) {
      case BetButtonState.bet:
        return AppColors.aviatorEighteenthColor;
      case BetButtonState.cancel:
        return AppColors.aviatorTwentySixthColor;
      case BetButtonState.cashout:
        return AppColors.aviatorSeventeenthColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback? onPressed;
    switch (state) {
      case BetButtonState.bet:
        onPressed = onBet;
        break;
      case BetButtonState.cancel:
        onPressed = onCancel;
        break;
      case BetButtonState.cashout:
        onPressed = onCashout;
        break;
    }

    return SizedBox(
      height: 108,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _getColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          _getLabel(),
          style: Theme.of(context).textTheme.aviatorBodyTitleMdeium,
        ),
      ),
    );
  }
}
