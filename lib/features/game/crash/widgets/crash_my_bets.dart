import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/game/crash/providers/crash_my_bets_provider.dart';

class CrashMyBets extends ConsumerStatefulWidget {
  const CrashMyBets({super.key});

  @override
  ConsumerState<CrashMyBets> createState() => _CrashBetsState();
}

class _CrashBetsState extends ConsumerState<CrashMyBets> {
  bool _isPreviousHand = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(crashMyBetsHistoryProvider.notifier).fetchMyBetsHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final betHistoryAsync = ref.watch(crashMyBetsHistoryProvider);

    return betHistoryAsync.when(
      loading: () => Container(
        height: 400,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.crashPrimaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.crashThirtyFourColor,
          ),
        ),
      ),
      error: (error, stackTrace) => Container(
        height: 400,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.crashEleventhColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Error: $error',
            style: Theme.of(context).textTheme.crashBodyLargeSecondary,
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
              color: AppColors.crashPrimaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'No bets found',
                style: Theme.of(context).textTheme.crashBodyLargeSecondary,
              ),
            ),
          );
        }
        return Container(
          height: 400,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.crashPrimaryColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.crashTwelfthColor, width: 1),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL BETS: ${betHistory.data.length}',
                    style: Theme.of(
                      context,
                    ).textTheme.crashBodyTitleSmallSecondary,
                  ),
                  //! Switch for PREVIOUS HAND
                  CustomElevatedButton(
                    width: 125,
                    height: 28,
                    padding: const EdgeInsets.only(
                      left: 7,
                      right: 7,
                      top: 5,
                      bottom: 4,
                    ),
                    borderColor: AppColors.crashThirtySixthColor,
                    borderRadius: 30,
                    backgroundColor: AppColors.crashTwentyFirstColor,
                    onPressed: () {
                      log('CRASH Previous hand button pressed');
                      setState(() {
                        _isPreviousHand = !_isPreviousHand;
                      });
                      if (_isPreviousHand) {
                        ref
                            .read(crashMyBetsHistoryProvider.notifier)
                            .fetchMyBetsHistory(page: 2);
                      } else {
                        ref
                            .read(crashMyBetsHistoryProvider.notifier)
                            .fetchMyBetsHistory(page: 1);
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
                            color: AppColors.crashSecondaryColor,
                          ),
                        ),
                        Text(
                          'Previous hand',
                          style: Theme.of(
                            context,
                          ).textTheme.crashBodyLargeSecondary,
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
                          ).textTheme.crashBodyMediumThird,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Bet, INR',
                          style: Theme.of(
                            context,
                          ).textTheme.crashBodyMediumThird,
                        ),
                      ),

                      Text(
                        'X',
                        style: Theme.of(context).textTheme.crashBodyMediumThird,
                      ),
                      SizedBox(width: 28),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Cashout INR',
                          style: Theme.of(
                            context,
                          ).textTheme.crashBodyMediumThird,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '',
                          style: Theme.of(
                            context,
                          ).textTheme.crashBodyMediumThird,
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

                      Color? bgColor =
                          (bet.payout == 0.0 && bet.cashoutAt == 0.0)
                          ? AppColors.crashThirtySixthColor
                          : AppColors.crashThirtySeventhColor;

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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('HH:mm').format(
                                        bet.placedAt.add(
                                          const Duration(hours: 5, minutes: 30),
                                        ),
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.crashBodyTitleSmallSecondary,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      //         bet['date'],
                                      DateFormat('dd-MM-yyyy').format(
                                        bet.placedAt.add(
                                          const Duration(hours: 5, minutes: 30),
                                        ),
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.crashBodyMediumFourth,
                                      //  overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),

                              // 📌 Bet, INR
                              Expanded(
                                flex: 1,
                                child: Text(
                                  //     bet['betINR'],
                                  bet.stake.toString(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.crashBodyTitleSmallSecondary,
                                ),
                              ),

                              // 📌 X
                              Container(
                                height: 28,
                                width: 50,

                                decoration: BoxDecoration(
                                  color: Color(0XFF271777),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    //    bet['x'].toString(),
                                    //
                                    bet.cashoutAt.toString(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.crashbodySmallPrimary,
                                  ),
                                ),
                              ),

                              // 📌 Cashout
                              Expanded(
                                flex: 1,
                                child: Text(
                                  //    bet['cashoutINR'],
                                  formatNum(bet.payout),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.crashBodyTitleSmallSecondary,
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
                                      color: AppColors.crashThirtyFivethColor,
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
