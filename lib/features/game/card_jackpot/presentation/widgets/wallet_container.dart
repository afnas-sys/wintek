import 'package:flutter/material.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/button.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';

import 'package:wintek/utils/app_colors.dart';
import 'package:wintek/utils/app_images.dart';

class WalletContainer extends StatelessWidget {
  const WalletContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: 126,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.cardSecondPrimaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      child: Image.asset(
                        AppImages.wallet,
                        width: 40,
                        height: 40,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Total',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        AppText(
                          text: 'Wallet balance',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.cardUnfocusedColor,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    AppText(
                      text: '₹5000',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.autorenew,
                        color: AppColors.cardUnfocusedColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  hasBorder: false,
                  text: 'Deposit',
                  onPressed: () {},
                  backgroundColor: AppColors.depositButtonColor,
                  textColor: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  borderRadius: 30,
                ),
                CustomElevatedButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  hasBorder: false,
                  text: 'Withdrawal',
                  onPressed: () {},
                  backgroundColor: AppColors.withdrowalButtonColor,
                  textColor: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  borderRadius: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
