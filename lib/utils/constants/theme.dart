import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wintek/utils/constants/app_colors.dart';

ThemeData theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.aviatorSixteenthColor),
  //! scaffold
  scaffoldBackgroundColor: AppColors.bgScaffoldAuthScreen,

  //!appbar
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.bgAppbarAuthScreen,
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

  //!_________________________________________Authentication______________________________________

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
    color: Color(0x80FFFFFF),
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

  // vasil changed the color
  TextStyle get authBodyMediumPrimary => GoogleFonts.roboto(
    color: Color(0xFFA395EE),
    // color: AppColors.authFourthColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  TextStyle get authBodyMediumThird => GoogleFonts.roboto(
    color: Colors.white,
    // color: AppColors.authFourthColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  TextStyle get authBodyMediumSecondary => GoogleFonts.roboto(
    color: AppColors.authTertiaryColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  //!________________________________Aviator_____________________________________

  TextStyle get aviatorDisplayLarge => GoogleFonts.roboto(
    color: AppColors.aviatorTertiaryColor,
    fontSize: 70,
    fontWeight: FontWeight.w600,
  );

  TextStyle get aviatorHeadlineSmall => GoogleFonts.roboto(
    color: AppColors.aviatorTertiaryColor,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  TextStyle get aviatorBodyTitleMdeium => GoogleFonts.roboto(
    color: AppColors.aviatorTertiaryColor,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  TextStyle get aviatorBodyLargePrimary => GoogleFonts.roboto(
    color: AppColors.textPrimaryColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  TextStyle get aviatorBodyLargeSecondary => GoogleFonts.roboto(
    color: AppColors.aviatorSixthColor,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  TextStyle get aviatorBodyMediumPrimary => GoogleFonts.roboto(
    color: AppColors.aviatorTertiaryColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  TextStyle get aviatorBodyMediumSecondary => GoogleFonts.roboto(
    color: AppColors.aviatorSixteenthColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  TextStyle get aviatorbodySmallPrimary => GoogleFonts.roboto(
    color: AppColors.aviatorTertiaryColor,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  TextStyle get aviatorbodySmallSecondary => GoogleFonts.roboto(
    color: AppColors.aviatorTwentyFourthColor,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  //!________________________________Home_____________________________________

  TextStyle get homeSmallPrimary => GoogleFonts.roboto(
    color: AppColors.textPrimaryColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  //!________________________________Wallet_____________________________________

  TextStyle get walletDisplaySmallPrimary => GoogleFonts.roboto(
    color: AppColors.walletEighthColor,
    fontSize: 34,
    fontWeight: FontWeight.w500,
  );
  TextStyle get walletTitleMediumPrimary => GoogleFonts.roboto(
    color: AppColors.walletEighthColor,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  TextStyle get walletBodyMediumPrimary => GoogleFonts.roboto(
    color: AppColors.walletEighthColor,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  TextStyle get walletBodyMediumSecondary => GoogleFonts.roboto(
    color: AppColors.walletSeventeenthColor,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  TextStyle get walletSmallPrimary => GoogleFonts.roboto(
    color: AppColors.walletEighthColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  TextStyle get walletSmallSecondary => GoogleFonts.roboto(
    color: AppColors.walletSeventhColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  TextStyle get walletBodySmallPrimary => GoogleFonts.roboto(
    color: AppColors.walletTwelfthColor,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  TextStyle get walletBodySmallSecondary => GoogleFonts.roboto(
    color: AppColors.walletEighteenthColor,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  //!________________________________Offers_____________________________________

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
}
