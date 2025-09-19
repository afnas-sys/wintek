import 'package:flutter/material.dart';
import 'package:wintek/features/wallet/widget/available_balance_container.dart';
import 'package:wintek/features/wallet/widget/transaction_history.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.walletPrimaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // Wallet balance container
            Padding(
              padding: const EdgeInsets.all(20),
              child: AvailableBalanceContainer(),
            ),

            // Deposit + Withdraw buttons
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      backgroundColor: AppColors.walletFifthColor,
                      borderColor: AppColors.walletFifthColor,
                      height: 50,
                      borderRadius: 50,
                      padding: const EdgeInsets.all(14),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Deposit',
                            style: Theme.of(
                              context,
                            ).textTheme.walletSmallSecondary,
                          ),
                          const SizedBox(width: 12),
                          Image.asset(
                            AppImages.depositIcon,
                            height: 22,
                            width: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomElevatedButton(
                      backgroundColor: AppColors.walletSixthColor,
                      borderColor: AppColors.walletNinthColor,
                      height: 50,
                      borderRadius: 50,
                      padding: const EdgeInsets.all(14),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Withdraw',
                            style: Theme.of(
                              context,
                            ).textTheme.walletSmallPrimary,
                          ),
                          const SizedBox(width: 12),
                          Image.asset(
                            AppImages.withdrawIcon,
                            height: 22,
                            width: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Transaction history
            Expanded(child: TransactionHistory()),
          ],
        ),
      ),
    );
  }
}
