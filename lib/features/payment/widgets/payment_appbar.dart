import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';

PreferredSizeWidget paymentAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: const Color(0xFF140A2D),
    leading: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Icon(
        Icons.arrow_back,
        size: 24,
        color: AppColors.aviatorTertiaryColor,
      ),
    ),
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.paymentBodyLargePrimary,
    ),
    centerTitle: true,
    scrolledUnderElevation: 0,
    elevation: 0,
  );
}
