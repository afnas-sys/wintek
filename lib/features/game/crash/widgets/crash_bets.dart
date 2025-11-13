import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/game/aviator/providers/bet_history_provider.dart';

class CrashBets extends ConsumerStatefulWidget {
  const CrashBets({super.key});

  @override
  ConsumerState<CrashBets> createState() => _CrashBetsState();
}

class _CrashBetsState extends ConsumerState<CrashBets> {
  bool _isPreviousHand = false;
  List<Map<String, dynamic>> crashBets = [
    {
      'time': '12:30',
      'date': '01/01/2023',
      'betINR': '100',
      'x': '2.5',
      'cashoutINR': '250',
    },
    {
      'time': '12:30',
      'date': '01/01/2023',
      'betINR': '150',
      'x': ' 3.0',
      'cashoutINR': '450',
    },
    {
      'time': '12:30',
      'date': '01/01/2023',
      'betINR': '200',
      'x': ' 1.8',
      'cashoutINR': '360',
    },
    {
      'time': '12:30',
      'date': '01/01/2023',
      'betINR': '250',
      'x': '4.0',
      'cashoutINR': '1000',
    },
    {
      'time': '12:30',
      'date': '01/01/2023',
      'betINR': '300',
      'x': '2.0',
      'cashoutINR': '600',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.aviatorTertiaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.aviatorFifteenthColor, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL BETS: ${crashBets.length}',
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
                  bottom: 4,
                ),
                borderColor: AppColors.aviatorThirtyEightColor,
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
                        color: AppColors.aviatorSixthColor,
                      ),
                    ),
                    Text(
                      'Previous hand',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorBodyMediumFourth,
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
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
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
                      'Cashout INR',
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
                itemCount: crashBets.length,
                separatorBuilder: (context, index) => SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final bet = crashBets[index];
                  // String formatNum(num? value) =>
                  //     value?.toStringAsFixed(2) ?? '0.00';

                  bool isHighlighted = index == 0;
                  Color? bgColor = isHighlighted
                      ? AppColors.aviatorThirtyEightColor
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
                                  bet['time'],
                                  // DateFormat('HH:mm').format(
                                  //   bet.placedAt.add(
                                  //     const Duration(hours: 5, minutes: 30),
                                  //   ),
                                  // ),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.aviatorBodyLargePrimary,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  bet['date'],
                                  // DateFormat('dd-MM-yyyy').format(
                                  //   bet.placedAt.add(
                                  //     const Duration(hours: 5, minutes: 30),
                                  //   ),
                                  // ),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.aviatorBodyMediumFourth,
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
                              bet['betINR'],
                              // bet.stake.toString(),
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
                                bet['x'].toString(),
                                //
                                // bet.cashoutAt.toString(),
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
                              bet['cashoutINR'],
                              //  formatNum(),
                              textAlign: TextAlign.center,
                              style: Theme.of(
                                context,
                              ).textTheme.aviatorBodyLargePrimary,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
  }
}
