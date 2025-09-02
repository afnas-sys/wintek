// import 'package:flutter/material.dart';
// import 'package:wintek/features/game/card_jackpot/wintek/widgets/text.dart';

// class AppButton extends StatelessWidget {
//   final VoidCallback? onPressed;
//   final String? text;
//   final Color? color;
//   final double? width;
//   final double? height;
//   final TextStyle? textStyle;
//   final IconData? icon;

//   const AppButton({
//     super.key,
//     this.onPressed,
//     this.text,
//     this.color,
//     this.width,
//     this.height,
//     this.textStyle,
//     this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {},
//       child: AppText(
//         text: text ?? '',
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//         color: Colors.white,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:wintek/utils/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text; // Optional text
  final Widget? child; // Optional custom widget
  final VoidCallback onPressed;
  final double borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final Widget? icon;
  final double? width;
  final double? height;
  final Color borderColor;
  final bool hasBorder;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double? elevation;

  const CustomElevatedButton({
    super.key,
    this.text,
    this.child,
    required this.onPressed,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.icon,
    this.width,
    this.height,
    this.borderColor = AppColors.cardPrimaryColor,
    this.hasBorder = true,
    this.textColor = AppColors.cardPrimaryColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.elevation,
  }) : assert(
         text != null || child != null,
         'Either text or child must be provided',
       );

  @override
  Widget build(BuildContext context) {
    Widget content =
        child ??
        Text(
          text ?? '',
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: hasBorder ? BorderSide(color: borderColor) : BorderSide.none,
          ),
          padding: padding,
          elevation: elevation ?? 0, // 🔹 if null, default = flat button
        ),
        onPressed: onPressed,
        child: icon == null
            ? content
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [icon!, const SizedBox(width: 8), content],
              ),
      ),
    );
  }
}
