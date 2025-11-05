import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/game/aviator/providers/user_provider.dart';

class AvailableBalanceContainer extends ConsumerStatefulWidget {
  const AvailableBalanceContainer({super.key});

  @override
  ConsumerState<AvailableBalanceContainer> createState() =>
      _AvailableBalanceContainerState();
}

class _AvailableBalanceContainerState
    extends ConsumerState<AvailableBalanceContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
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
          userAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (userModel) {
              if (userModel == null) {
                return const Center(child: Text('No data available'));
              }
              final user = userModel.data;
              return Text(
                '₹${user.wallet.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.walletDisplaySmallPrimary,
              );
            },
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
