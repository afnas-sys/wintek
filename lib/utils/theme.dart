import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wintek/utils/app_colors.dart';

ThemeData theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.textFifthColor),
  //! scaffold
  scaffoldBackgroundColor: AppColors.authPrimaryColor,

  //!appbar
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.authSecondaryColor,
    iconTheme: IconThemeData(color: AppColors.authFifthColor),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
  ),

  //! icon
  iconTheme: IconThemeData(color: AppColors.authPrimaryColor),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(AppColors.authFifthColor),
    ),
  ),
);

//!text
extension CustomTextStyle on TextTheme {
  /*
  !Use it for reference for Naming
   static const displayLarge = TextStyle(fontSize: 57, fontWeight: FontWeight.bold);
  static const displayMedium = TextStyle(fontSize: 45, fontWeight: FontWeight.w600);
  static const displaySmall = TextStyle(fontSize: 36, fontWeight: FontWeight.w600);

  static const headlineLarge = TextStyle(fontSize: 32, fontWeight: FontWeight.w600);
  static const headlineMedium = TextStyle(fontSize: 28, fontWeight: FontWeight.w500);
  static const headlineSmall = TextStyle(fontSize: 24, fontWeight: FontWeight.w500);

   // Titles
  static const titleLarge = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  static const titleMedium = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const titleSmall = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  // Body
  static const bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
  static const bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
  static const bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.normal);

  // Special
  static const button = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
  */

  //!-------Authentication--------

  TextStyle get authHeadlineMedium => GoogleFonts.roboto(
    color: AppColors.authFifthColor,
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );
  TextStyle get authTitleLarge => GoogleFonts.roboto(
    color: AppColors.authFifthColor,
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  TextStyle get authBodyLargePrimary => GoogleFonts.roboto(
    color: AppColors.authFourthColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  TextStyle get authBodyLargeSecondary => GoogleFonts.roboto(
    color: AppColors.authFifthColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  TextStyle get authBodyLargeTertiary => GoogleFonts.roboto(
    color: AppColors.authSixthColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  TextStyle get authBodyLargeFourth => GoogleFonts.roboto(
    color: AppColors.authTertiaryColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  TextStyle get authBodyMediumPrimary => GoogleFonts.roboto(
    color: AppColors.authFourthColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  TextStyle get authBodyMediumSecondary => GoogleFonts.roboto(
    color: AppColors.authTertiaryColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  //!-----------------------------------------------------------------------------------------------------------

  //!AppBar

  //! Body
  //large
  TextStyle get bodyLargeTitle3Primary => GoogleFonts.roboto(
    color: AppColors.textPrimaryColor,
    fontSize: 28,
    fontWeight: FontWeight.w500,
  );

  //medium
  TextStyle get bodyMediumTitle3Primary => GoogleFonts.roboto(
    color: AppColors.textPrimaryColor,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  TextStyle get bodyMediumTitle4Primary => GoogleFonts.roboto(
    color: AppColors.textPrimaryColor,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  TextStyle get bodyMedium18Title3Primary => GoogleFonts.roboto(
    color: AppColors.textPrimaryColor,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  //small

  TextStyle get bodyMediumPrimary => GoogleFonts.roboto(
    color: AppColors.textPrimaryColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  TextStyle get bodyMediumPrimaryBold => GoogleFonts.roboto(
    color: AppColors.textPrimaryColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // TextStyle get bodyMediumSecondary => GoogleFonts.roboto(
  //   color: AppColors.textSecondaryColor,
  //   fontSize: 16,
  //   fontWeight: FontWeight.w400,
  // );

  // TextStyle get bodyMediumTertiary => GoogleFonts.roboto(
  //   color: AppColors.textTertiaryColor,
  //   fontSize: 16,
  //   fontWeight: FontWeight.w400,
  // );

  TextStyle get bodySmallPrimaryBold => GoogleFonts.roboto(
    color: AppColors.textPrimaryColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  TextStyle get bodySmallSecondary => GoogleFonts.roboto(
    color: AppColors.textFifthColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  TextStyle get bodySmallSecondaryBold => GoogleFonts.roboto(
    color: AppColors.textFourthColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  TextStyle get bodySmallPrimary => GoogleFonts.roboto(
    color: AppColors.textPrimaryColor,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  TextStyle get bodySmallTertiary => GoogleFonts.roboto(
    color: AppColors.textSixthColor,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  //Nav bar Label
  TextStyle get navBarSelectedLabel => GoogleFonts.roboto(
    color: AppColors.textPrimaryColor,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}
