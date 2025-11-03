import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/router/routes_names.dart';

import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/features/game/aviator/providers/user_provider.dart';

class BalanceContainer extends ConsumerStatefulWidget {
  const BalanceContainer({super.key});

  @override
  ConsumerState<BalanceContainer> createState() => _BalanceContainerState();
}

class _BalanceContainerState extends ConsumerState<BalanceContainer> {
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

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (userModel) {
        if (userModel == null) {
          return const Center(child: Text('No data available'));
        }
        final user = userModel.data;
        String formatNum(num? value) => value?.toStringAsFixed(2) ?? '0.00';
        return Container(
          padding: const EdgeInsets.all(22),
          width: 396,
          height: 134,
          decoration: BoxDecoration(
            color: AppColors.aviatorSecondaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.aviatorBodyTitleMdeium,
                  children: [
                    TextSpan(text: 'Available Balance: '),
                    TextSpan(text: '₹${formatNum(user.wallet)}'),
                  ],
                ),
              ),

              SizedBox(height: 19),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      //!Button for withdraw
                      _withdrawButton(context),
                      SizedBox(width: 20),

                      //!Button for deposit
                      _depositButton(context),
                    ],
                  ),

                  //! icon for Refresh
                  _refreshButton(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //! Button for withdraw
  Widget _withdrawButton(BuildContext context) {
    return CustomElevatedButton(
      hasBorder: false,
      onPressed: () {
        Navigator.pushNamed(context, RoutesNames.withdraw);
      },
      backgroundColor: AppColors.aviatorFourthColor,
      borderRadius: 30,
      padding: EdgeInsets.only(left: 23, right: 23, top: 10, bottom: 10),
      height: 40,
      width: 111,
      child: Text(
        'Withdraw',
        style: Theme.of(context).textTheme.aviatorBodyLargeSecondary,
      ),
    );
  }

  //! Button for deposit
  Widget _depositButton(BuildContext context) {
    return CustomElevatedButton(
      hasBorder: false,
      onPressed: () {
        Navigator.pushNamed(context, RoutesNames.deposit);
      },
      backgroundColor: AppColors.aviatorFifthColor,
      borderRadius: 30,
      padding: EdgeInsets.only(left: 23, right: 23, top: 10, bottom: 10),
      height: 40,
      width: 100,
      child: Text(
        'Deposit',
        style: Theme.of(context).textTheme.aviatorBodyLargeSecondary,
      ),
    );
  }

  //! Refresh Button
  Widget _refreshButton() {
    return Row(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            ref.read(userProvider.notifier).fetchUser();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(AppImages.refresh, height: 20, width: 20),
          ),
        ),
      ],
    );
  }
}
