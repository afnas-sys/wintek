import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:winket/utils/app_colors.dart';
import 'package:winket/utils/widgets/custom_elevated_button.dart';

class AviatorButtons extends StatelessWidget {
  const AviatorButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // #1
        CustomElevatedButton(
          onPressed: () {},
          text: '1.02x',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          textColor: AppColors.buttonTertiaryTextColor,
          hasBorder: false,
          borderRadius: 30,
          padding: EdgeInsetsGeometry.only(
            left: 13,
            right: 13,
            top: 8,
            bottom: 8,
          ),
          height: 32,
          width: 59.33,
          backgroundColor: AppColors.buttonFivethColor,
        ),

        // #2
        CustomElevatedButton(
          onPressed: () {},
          text: '3.52x',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          textColor: AppColors.buttonTertiaryTextColor,
          hasBorder: false,
          borderRadius: 30,
          padding: EdgeInsetsGeometry.only(
            left: 13,
            right: 13,
            top: 8,
            bottom: 8,
          ),
          height: 32,
          width: 59.33,
          backgroundColor: AppColors.buttonSixthColor,
        ),

        // #3
        CustomElevatedButton(
          onPressed: () {},
          text: '4.87x',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          textColor: AppColors.buttonTertiaryTextColor,
          hasBorder: false,
          borderRadius: 30,
          padding: EdgeInsetsGeometry.only(
            left: 13,
            right: 13,
            top: 8,
            bottom: 8,
          ),
          height: 32,
          width: 59.33,
          backgroundColor: AppColors.buttonSixthColor,
        ),

        // #4
        CustomElevatedButton(
          onPressed: () {},
          text: '27.76x',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          textColor: AppColors.buttonTertiaryTextColor,
          hasBorder: false,
          borderRadius: 30,
          padding: EdgeInsetsGeometry.only(
            left: 13,
            right: 13,
            top: 8,
            bottom: 8,
          ),
          height: 32,
          width: 59.33,
          backgroundColor: AppColors.buttonSeventhColor,
        ),

        // #5
        CustomElevatedButton(
          onPressed: () {},
          text: '1.02x',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          textColor: AppColors.buttonTertiaryTextColor,
          hasBorder: false,
          borderRadius: 30,
          padding: EdgeInsetsGeometry.only(
            left: 13,
            right: 13,
            top: 8,
            bottom: 8,
          ),
          height: 32,
          width: 59.33,
          backgroundColor: AppColors.buttonFivethColor,
        ),

        // #6
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonEighthColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              side: const BorderSide(
                color: AppColors.buttonborderSecondaryColor,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            minimumSize: Size(59.33, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                FontAwesomeIcons.clock,
                size: 16,
                color: AppColors.iconPrimaryColor,
              ),
              SizedBox(width: 4),
              Icon(
                FontAwesomeIcons.angleDown,
                size: 16,
                color: AppColors.iconPrimaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
