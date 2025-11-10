import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';

class CrashButtons extends ConsumerStatefulWidget {
  const CrashButtons({super.key});

  @override
  ConsumerState<CrashButtons> createState() => _CrashButtonsState();
}

class _CrashButtonsState extends ConsumerState<CrashButtons> {
  bool showBalance = false;

  // Hardcoded crash multipliers for demonstration
  final List<String> multipliers = [
    '11.5x',
    '3.5x',
    '1.8x',
    '7.2x',
    '2.1x',
    '4.8x',
    '1.5x',
    '9.3x',
    '2.7x',
    '5.1x',
    '1.9x',
    '6.4x',
    '3.2x',
    '8.7x',
    '1.3x',
  ];

  // colors
  Color _getColor(String text) {
    final value = double.tryParse(text.replaceAll("x", "")) ?? 0;
    if (value < 2) {
      return AppColors.crashNinthColor;
    } else if (value < 10) {
      return AppColors.crashFifteenthColor;
    } else {
      return AppColors.crashFourteenthColor;
    }
  }

  // container for showing the multiplied amount
  Widget _chip(String text, BuildContext context) {
    final color = _getColor(text);
    return Container(
      height: 32,
      width: 55,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: Theme.of(context).textTheme.crashbodySmallPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // first row → 4 chips + button
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int i = 0; i < 4 && i < multipliers.length; i++)
              Expanded(child: _chip(multipliers[i], context)),
            // Button for showing Balance history of the multiplier
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => showBalance = !showBalance),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.crashTwentySixthColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: AppColors.crashTwentySeventhColor),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  minimumSize: const Size(55, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      FontAwesomeIcons.clock,
                      size: 16,
                      color: AppColors.crashPrimaryColor,
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      showBalance
                          ? FontAwesomeIcons.angleUp
                          : FontAwesomeIcons.angleDown,
                      size: 16,
                      color: AppColors.crashPrimaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        //  second row → wrap chips in multiple lines
        if (showBalance)
          Wrap(
            runSpacing: 8,
            children: [
              for (int i = 4; i < multipliers.length; i++)
                _chip(multipliers[i], context),
            ],
          ),
      ],
    );
  }
}
