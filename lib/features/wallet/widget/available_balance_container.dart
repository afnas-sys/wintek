import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';

class AvailableBalanceContainer extends StatelessWidget {
  const AvailableBalanceContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(23),
      width: double.infinity,
      // height: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.walletFourthColor, width: 1),
        image: DecorationImage(
          image: AssetImage(AppImages.walletImage),
          fit: BoxFit.fill,
        ),
        // gradient: LinearGradient(
        //   colors: [
        //     AppColors.walletSecondaryColor,
        //     AppColors.walletThirdColor,
        //     AppColors.walletSecondaryColor,
        //   ],
        // ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 32,
            width: 127,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.walletTenthColor),
              color: AppColors.walletEleventhColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                'Available Balance',
                style: Theme.of(context).textTheme.walletBodySmallPrimary,
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            '₹12,540.00',
            style: Theme.of(context).textTheme.walletDisplaySmallPrimary,
          ),
          SizedBox(height: 6),
          Text(
            'Available to play & withdraw',
            style: Theme.of(context).textTheme.walletBodySmallPrimary,
          ),
        ],
      ),
    );
  }
}
