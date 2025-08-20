import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winket/utils/app_colors.dart';

ThemeData theme = ThemeData(
  //! scaffold
  scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,

  //!appbar
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.appBarColor,
    iconTheme: IconThemeData(color: AppColors.iconPrimaryColor),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
  ),

  //! icon
  iconTheme: IconThemeData(color: AppColors.iconPrimaryColor),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(AppColors.iconPrimaryColor),
    ),
  ),

 

  


 //!text
  // textTheme: GoogleFonts.robotoTextTheme().copyWith(
  //   bodyLarge: TextStyle(
  //     color: AppColors.textPrimaryColor,
  //     fontSize: 28,
  //     fontWeight: FontWeight.bold,
  //   ),
    // bodyMedium: TextStyle(
    //   color: AppColors.textSecondaryColor,
    //   fontSize: 16,
    //   fontWeight: FontWeight.w400,
    // ),
    // bodySmall: TextStyle(
    //   color: AppColors.textPrimaryColor,
    //   fontSize: 16,
    //   fontWeight: FontWeight.w400,
    // ),
  
  //),
);


 //!text
extension CustomTextStyle  on TextTheme{
  //!AppBar
  TextStyle get appBartitle => GoogleFonts.roboto(
    color: AppColors.textPrimaryColor,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  TextStyle get appBarSubTitle => GoogleFonts.roboto(
    color: AppColors.textSecondaryColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

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

    TextStyle get bodyMediumSecondary => GoogleFonts.roboto(
    color: AppColors.textSecondaryColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  TextStyle get bodyMediumTertiary => GoogleFonts.roboto(
    color: AppColors.textTertiaryColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  TextStyle get bodySmallPrimary => GoogleFonts.roboto(
    color: AppColors.textPrimaryColor,
    fontSize: 12,
  );

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
}
