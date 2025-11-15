import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/router/routes_names.dart';
import 'package:wintek/features/game/aviator/providers/user_provider.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/features/game/card_jackpot/providers/wallet_provider.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';

class WalletContainer extends ConsumerStatefulWidget {
  const WalletContainer({super.key});

  @override
  ConsumerState<WalletContainer> createState() => _WalletContainerState();
}

class _WalletContainerState extends ConsumerState<WalletContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final futureWallet = ref.watch(walletBalanceProvider);
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        //   color: AppColors.cardSecondPrimaryColor,
        image: const DecorationImage(
          image: AssetImage(AppImages.walletBg),
          fit: BoxFit.cover,
        ),
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
                        color: AppColors.walletEighthColor,

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
                          color: AppColors.walletEighthColor,
                        ),
                        AppText(
                          text: 'Wallet balance',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.walletEighthColor,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    futureWallet.when(
                      data: (walletBalance) => AppText(
                        text:
                            '₹ ${walletBalance?.data.balance.toStringAsFixed(2) ?? '0.00'}',
                        fontSize: width > 400 ? 22 : 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.walletEighthColor,
                      ),
                      error: (e, s) => AppText(
                        text: '₹ 0',
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                      loading: () => SizedBox.shrink(),
                    ),
                    InkWell(
                      splashColor: AppColors.cardPrimaryColor,
                      child: Icon(
                        Icons.autorenew,
                        color: AppColors.walletEighthColor,
                      ),
                      onTap: () async {
                        final wallet = await ref.refresh(
                          walletBalanceProvider.future,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.cardPrimaryColor,
                            content: Text(
                              wallet?.message ?? 'Fetched wallet successfully',
                            ),
                          ),
                        );
                      },
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
                    horizontal: 40,
                    vertical: 12,
                  ),
                  hasBorder: false,
                  text: 'Deposit',
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesNames.deposit);
                  },
                  backgroundColor: AppColors.walletNineteenthColor,
                  textColor: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  borderRadius: 30,
                ),
                CustomElevatedButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  hasBorder: false,
                  text: 'Withdrawal',
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesNames.withdraw);
                  },
                  backgroundColor: AppColors.walletTwentieththColor,
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
