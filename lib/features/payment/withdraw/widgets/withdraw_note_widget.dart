import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';

class WithdrawNoteWidget extends StatelessWidget {
  const WithdrawNoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 26),
      color: AppColors.paymentEleventhColor,
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(fontSize: 14, height: 1.4),
          children: [
            TextSpan(
              text: 'Note : ',
              style: TextStyle(color: AppColors.paymentTwelfthColor),
            ),
            TextSpan(
              text:
                  '\nWithdraw Time (08:00 AM to 12:00PM)\nMinimum Withdrawal Amount: ₹100',
              style: TextStyle(color: AppColors.paymentThirteenthColor),
            ),
          ],
        ),
      ),
    );
  }
}
