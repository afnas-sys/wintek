
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winket/utils/widgets/custom_elevated_button.dart';
import 'package:winket/utils/app_colors.dart';

class BalanceContainer extends StatelessWidget {
  const BalanceContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      width: 396,
      height: 134,
      decoration: BoxDecoration(
        color: AppColors.bgFourteenthColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance: ₹0.00',
            style: GoogleFonts.roboto(
              color: AppColors.textPrimaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 19),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Button for withdraw
              CustomElevatedButton(
                hasBorder: false,
                onPressed: () {},
                text: 'Withdraw',
                textColor: AppColors.buttonPrimaryTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                backgroundColor: AppColors.bgFourthColor,
                borderRadius: 30,
                padding: EdgeInsets.only(
                  left: 23,
                  right: 23,
                  top: 10,
                  bottom: 10,
                ),
                height: 40,
                width: 111,
              ),
              SizedBox(width: 20),
              //Button for deposit
              CustomElevatedButton(
                hasBorder: false,
                onPressed: () {},
                text: 'Deposit',
                textColor: AppColors.buttonPrimaryTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                backgroundColor: AppColors.bgPrimaryColor,
                borderRadius: 30,
                padding: EdgeInsets.only(
                  left: 23,
                  right: 23,
                  top: 10,
                  bottom: 10,
                ),
                height: 40,
                width: 100,
              ),
              SizedBox(width: 84),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {},
                child: Icon(
                  FontAwesomeIcons.rotate,
                  size: 20,
                  color: AppColors.textPrimaryColor,
                  weight: 10,
                ),
              ),
              // IconButton(
              // padding: EdgeInsets.zero,
              // constraints: BoxConstraints(),
              //   onPressed: () {},
              //   icon: Icon(FontAwesomeIcons.rotate, size: 20),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
