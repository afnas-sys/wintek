import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/router/routes_names.dart';
import 'package:wintek/features/game/aviator/providers/user_provider.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/features/game/card_jackpot/providers/wallet_provider.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'dart:async';

class WalletContainer extends ConsumerStatefulWidget {
  const WalletContainer({super.key});

  @override
  ConsumerState<WalletContainer> createState() => _WalletContainerState();
}

class _WalletContainerState extends ConsumerState<WalletContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).fetchUser();
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletBalanceProvider);
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
                        AppImages.wallet,
                        color: AppColors.walletEighthColor,
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
                    // Display balance
                    Builder(
                      builder: (context) {
                        final balanceVal =
                            walletState.valueOrNull?.data.balance;
                        final balanceStr =
                            balanceVal?.toStringAsFixed(2) ?? '0.00';
                        return AppText(
                          text: '₹ $balanceStr',
                          fontSize: width > 400 ? 22 : 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.walletEighthColor,
                        );
                      },
                    ),
                    InkWell(
                      splashColor: AppColors.cardPrimaryColor,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        child: RotationTransition(
                          turns: _controller,
                          child: Icon(
                            Icons.autorenew,
                            color: AppColors.walletEighthColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (!_controller.isAnimating) {
                          _controller.repeat();
                          Timer(const Duration(seconds: 1), () {
                            if (mounted) _controller.stop();
                          });
                        }
                        // Refresh by explicitly fetching (no blink)
                        ref
                            .read(walletBalanceProvider.notifier)
                            .fetchWalletBalance();
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
