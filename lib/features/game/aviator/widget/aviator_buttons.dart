import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/utils/app_colors.dart';
import 'package:wintek/utils/theme.dart';

class AviatorButtons extends StatefulWidget {
  const AviatorButtons({super.key});

  @override
  State<AviatorButtons> createState() => _AviatorButtonsState();
}

class _AviatorButtonsState extends State<AviatorButtons> {
  final List<String> multipliers = [
    "4.87x",
    "16.00x",
    "6.20x",
    "9.99x",
    "1.02x",
    "8.12x",
    "1.50x",
    "4.87x",
    "15.00x",
    "6.20x",
    "9.99x",
    "12.45x",
    "1.02x",
    "8.12x",
    "1.50x",
  ];

  bool showBalance = false;
  // colors
  Color _getColor(String text) {
    final value = double.tryParse(text.replaceAll("x", "")) ?? 0;
    if (value < 2) {
      return AppColors.aviatorSeventhColor;
    } else if (value < 10) {
      return AppColors.aviatorEighthColor;
    } else {
      return AppColors.aviatorNinthColor;
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
        style: Theme.of(context).textTheme.aviatorbodySmallPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // first row → 5 chips + button
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int i = 0; i < 5 && i < multipliers.length; i++)
              _chip(multipliers[i], context),
            // Button for showing Balance history of the multplier
            ElevatedButton(
              onPressed: () => setState(() => showBalance = !showBalance),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.aviatorTenthColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: AppColors.aviatorEleventhColor),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                minimumSize: const Size(55, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    FontAwesomeIcons.clock,
                    size: 16,
                    color: AppColors.aviatorTertiaryColor,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    showBalance
                        ? FontAwesomeIcons.angleUp
                        : FontAwesomeIcons.angleDown,
                    size: 16,
                    color: AppColors.aviatorTertiaryColor,
                  ),
                ],
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
              for (int i = 6; i < multipliers.length; i++)
                _chip(multipliers[i], context),
            ],
          ),
      ],
    );
  }
}
