import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';

class DepositNoteWidget extends StatefulWidget {
  const DepositNoteWidget({super.key});

  @override
  State<DepositNoteWidget> createState() => _DepositNoteWidgetState();
}

class _DepositNoteWidgetState extends State<DepositNoteWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      color: AppColors.paymentEleventhColor,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Note : \n',
              style: Theme.of(context).textTheme.paymentSmallFourth,
            ),
            TextSpan(
              text: 'In case of any queries & concerns contact us.',
              style: Theme.of(context).textTheme.paymentSmallFifth,
            ),
          ],
        ),
      ),
    );
  }
}
