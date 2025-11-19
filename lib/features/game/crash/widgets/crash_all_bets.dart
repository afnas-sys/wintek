import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/game/aviator/providers/aviator_round_provider.dart';

class CrashAllBets extends ConsumerStatefulWidget {
  const CrashAllBets({super.key});

  @override
  ConsumerState<CrashAllBets> createState() => _AllBetsState();
}

class _AllBetsState extends ConsumerState<CrashAllBets> {
  int _currentPage = 0;
  static const int _itemsPerPage = 50;

  void _showPreviousHand() {
    final totalPages = (_betsLength / _itemsPerPage).ceil();
    if (totalPages == 0) {
      // No bets/pages yet, nothing to paginate
      return;
    }
    setState(() {
      _currentPage = (_currentPage + 1) % totalPages;
    });
  }

  int get _betsLength =>
      ref.watch(aviatorBetsNotifierProvider)?.bets.length ?? 0;

  List<Map<String, dynamic>> crashAllBets = [
    {
      'time': '12:35',
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
                'TOTAL BETS: ${crashAllBets.length}',
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
                borderRadius: 30,
                backgroundColor: AppColors.aviatorTwentiethColor,
                onPressed: _showPreviousHand,
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
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'User',
                    style: Theme.of(
                      context,
                    ).textTheme.aviatorBodyMediumSecondary,
                  ),
                ),
                SizedBox(width: 35),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Bet',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.aviatorBodyMediumSecondary,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Mult.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.aviatorBodyMediumSecondary,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Cash out',
                    textAlign: TextAlign.end,
                    style: Theme.of(
                      context,
                    ).textTheme.aviatorBodyMediumSecondary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          crashAllBets.isEmpty || crashAllBets.toString().isEmpty
              ? Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(
                    'No bets yet',
                    style: Theme.of(context).textTheme.aviatorBodyMediumFourth,
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: crashAllBets.length,
                  separatorBuilder: (context, index) => SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    bool isHighlighted =
                        (_currentPage * _itemsPerPage + index) == 0 ||
                        (_currentPage * _itemsPerPage + index) == 1;
                    Color? bgColor = isHighlighted
                        ? AppColors.aviatorTwentyFirstColor
                        : AppColors.aviatorTwentySecondColor;
                    final bets = crashAllBets.toList()[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: bgColor, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            // 👤 Avatar
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                color: AppColors.aviatorTertiaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            SizedBox(width: 12),

                            // 📌 User
                            Expanded(
                              flex: 2,
                              child: Text(
                                bets['date'] ?? '',
                                style: Theme.of(
                                  context,
                                ).textTheme.aviatorBodyLargePrimary,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // 📌 Bet
                            Expanded(
                              flex: 1,
                              child: Text(
                                bets['betINR'] ?? '',
                                textAlign: TextAlign.center,
                                style: Theme.of(
                                  context,
                                ).textTheme.aviatorBodyLargePrimary,
                              ),
                            ),

                            // 📌 Mult
                            Expanded(
                              flex: 1,
                              child: isHighlighted
                                  ? Container(
                                      height: 32,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.aviatorThirtyFiveColor,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        bets['x'] ?? '',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.aviatorBodyLargeThird,
                                      ),
                                    )
                                  : const SizedBox(),
                            ),

                            // 📌 Cashout
                            Expanded(
                              flex: 1,
                              child: isHighlighted
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        bets['cashoutINR'] ?? '',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.aviatorBodyLargePrimary,
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
