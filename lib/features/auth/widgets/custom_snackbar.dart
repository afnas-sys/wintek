import 'package:flutter/material.dart';
import 'package:winket/utils/app_colors.dart';

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = AppColors.snackbarValidateColor,
    Color contentColor = AppColors.snackbarValidateTextColor,
    Duration duration = const Duration(seconds: 2),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: contentColor, fontSize: 16),
          ),
          backgroundColor: backgroundColor,
          duration: duration,
          behavior: behavior,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: (8)),
        ),
      );
  }
}
