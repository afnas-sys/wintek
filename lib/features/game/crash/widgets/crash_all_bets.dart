import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/game/crash/domain/models/crash_all_bets_model.dart';
import 'package:wintek/features/game/crash/providers/crash_round_provider.dart';

class CrashAllBets extends ConsumerStatefulWidget {
  const CrashAllBets({super.key});

  @override
  ConsumerState<CrashAllBets> createState() => _AllBetsState();
}

class _AllBetsState extends ConsumerState<CrashAllBets> {
  CrashAllBetsModel? _bets;

  List<dynamic> _getCurrentPageBets() {
    return _bets?.bets ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final betsAsync = ref.watch(crashBetsNotifierProvider);
    _bets = betsAsync;
    return Container(
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
            children: [
              Text(
                'TOTAL BETS: ${betsAsync?.count ?? 0}',
                style: Theme.of(context).textTheme.crashBodyTitleSmallSecondary,
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
                    style: Theme.of(context).textTheme.crashBodyMediumThird,
                  ),
                ),
                SizedBox(width: 35),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Bet',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.crashBodyMediumThird,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Mult.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.crashBodyMediumThird,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Cash out',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.crashBodyMediumThird,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          _getCurrentPageBets().isEmpty
              ? Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(
                    'No bets yet',
                    style: Theme.of(context).textTheme.crashBodyMediumFourth,
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _getCurrentPageBets().length,
                  separatorBuilder: (context, index) => SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    bool isHighlighted = index == 0 || index == 1;
                    Color? bgColor = isHighlighted
                        ? AppColors.crashThirtyEightColor
                        : AppColors.crashThirtyNinthColor;
                    final bets = _getCurrentPageBets()[index];

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
                                color: AppColors.crashPrimaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            SizedBox(width: 12),

                            // 📌 User
                            Expanded(
                              flex: 2,
                              child: Text(
                                bets?.user.userName ?? '',
                                style: Theme.of(
                                  context,
                                ).textTheme.crashBodyTitleSmallSecondary,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // 📌 Bet
                            Expanded(
                              flex: 1,
                              child: Text(
                                bets?.stake.toString() ?? '',
                                textAlign: TextAlign.center,
                                style: Theme.of(
                                  context,
                                ).textTheme.crashBodyTitleSmallSecondary,
                              ),
                            ),

                            // 📌 Mult
                            Expanded(
                              flex: 1,
                              child: Text(
                                bets?.cashoutAt.toString() ?? '',
                                style: Theme.of(
                                  context,
                                ).textTheme.crashBodyTitleSmallSecondary,
                              ),
                            ),

                            // 📌 Cashout
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  bets?.payout.toStringAsFixed(2) ?? '',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.crashBodyTitleSmallSecondary,
                                ),
                              ),
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
