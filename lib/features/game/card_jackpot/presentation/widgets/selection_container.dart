import 'package:flutter/material.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/core/constants/app_colors.dart';

class SelectContainer extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final String value;
  final VoidCallback onTap;

  const SelectContainer({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: index == selectedIndex
              ? AppColors.cardPrimaryColor
              : const Color(0xffF5F5F5),
        ),
        child: AppText(
          text: value,
          fontSize: 16,
          color: index != selectedIndex ? AppColors.cardUnfocusedColor : null,
        ),
      ),
    );
  }
}
