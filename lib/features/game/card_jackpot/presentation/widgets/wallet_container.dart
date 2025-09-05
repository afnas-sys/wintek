import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/features/game/card_jackpot/providers/wallet_provider/wallet_provider.dart';

import 'package:wintek/utils/constants/app_colors.dart';
import 'package:wintek/utils/constants/app_images.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';

class WalletContainer extends ConsumerWidget {
  const WalletContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final num walletBalance = ref.watch(walletBalanceAmountProvider);
    return Container(
      width: MediaQuery.of(context).size.width,
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
                  spacing: 10,
                  children: [
                    AppText(
                      text: '₹ $walletBalance',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                    InkWell(
                      child: Icon(
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
