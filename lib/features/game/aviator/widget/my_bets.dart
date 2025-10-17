import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/game/aviator/providers/bet_history_provider.dart';

class MyBets extends ConsumerStatefulWidget {
  const MyBets({super.key});

  @override
  ConsumerState<MyBets> createState() => _MyBetsState();
}

class _MyBetsState extends ConsumerState<MyBets> {
  bool _isPreviousHand = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(betHistoryProvider.notifier).fetchBetHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final betHistoryAsync = ref.watch(betHistoryProvider);
    return betHistoryAsync.when(
      loading: () => Container(
        height: 400,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.aviatorFourteenthColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Container(
        height: 400,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.aviatorFourteenthColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      data: (betHistory) {
        if (betHistory == null || betHistory.data.isEmpty) {
          return Container(
            height: 400,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.aviatorFourteenthColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'No bets found',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return Container(
          height: 400,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.aviatorFourteenthColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.aviatorFifteenthColor,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL BETS: ${betHistory.data.length}',
                    style: Theme.of(context).textTheme.aviatorBodyLargePrimary,
                  ),
                  //! Switch for PREVIOUS HAND
                  CustomElevatedButton(
                    width: 125,
                    height: 28,
                    padding: const EdgeInsets.only(
                      left: 7,
                      right: 7,
                      top: 5,
                      bottom: 6,
                    ),
                    borderRadius: 30,
                    backgroundColor: AppColors.aviatorTwentiethColor,
                    onPressed: () {
                      setState(() {
                        _isPreviousHand = !_isPreviousHand;
                      });
                      if (_isPreviousHand) {
                        ref
                            .read(betHistoryProvider.notifier)
                            .fetchBetHistory(page: 2);
                      } else {
                        ref
                            .read(betHistoryProvider.notifier)
                            .fetchBetHistory(page: 1);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          child: Image.asset(
                            AppImages.previousHand,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        Text(
                          'Previous hand',
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorBodyMediumPrimary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 36,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 1,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Date',
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorBodyMediumSecondary,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Bet, INR',
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorBodyMediumSecondary,
                        ),
                      ),

                      Text(
                        'X',
                        style: Theme.of(
                          context,
                        ).textTheme.aviatorBodyMediumSecondary,
                      ),
                      SizedBox(width: 28),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Cashout, INR',
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorBodyMediumSecondary,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '',
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorBodyMediumSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 8),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    clipBehavior: Clip.none,
                    padding: EdgeInsets.zero,
                    itemCount: betHistory.data.length,
                    separatorBuilder: (context, index) => SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final bet = betHistory.data[index];
                      String formatNum(num? value) =>
                          value?.toStringAsFixed(2) ?? '0.00';

                      bool isHighlighted = index == 0;
                      Color? bgColor = isHighlighted
                          ? AppColors.aviatorTwentySecondColor
                          : AppColors.aviatorTwentyFirstColor;

                      return Container(
                        width: double.infinity,
                        height: 66,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: bgColor, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              // 📌 Date
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('HH:mm').format(
                                        bet.placedAt.add(
                                          const Duration(hours: 5, minutes: 30),
                                        ),
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.aviatorBodyLargePrimary,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      DateFormat('dd-MM-yyyy').format(
                                        bet.placedAt.add(
                                          const Duration(hours: 5, minutes: 30),
                                        ),
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.aviatorBodyMediumPrimary,
                                    ),
                                  ],
                                ),
                              ),

                              // 📌 Bet, INR
                              Expanded(
                                flex: 1,
                                child: Text(
                                  bet.stake.toString(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.aviatorBodyLargePrimary,
                                ),
                              ),

                              // 📌 X
                              Container(
                                height: 28,
                                width: 50,

                                decoration: BoxDecoration(
                                  color: AppColors.aviatorTwentyThirdColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    bet.cashoutAt.toString(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.aviatorbodySmallSecondary,
                                  ),
                                ),
                              ),

                              // 📌 Cashout
                              Expanded(
                                flex: 1,
                                child: Text(
                                  formatNum(bet.payout),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.aviatorBodyLargePrimary,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'assets/images/shield.png',
                                      height: 22,
                                      width: 22,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.comment,
                                      size: 20,
                                      color: AppColors.aviatorSixteenthColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
