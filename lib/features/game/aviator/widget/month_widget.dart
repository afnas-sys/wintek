import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/game/aviator/providers/top_bets_provider.dart';

class MonthWidget extends ConsumerStatefulWidget {
  const MonthWidget({super.key});

  @override
  ConsumerState<MonthWidget> createState() => _MonthWidgetState();
}

class _MonthWidgetState extends ConsumerState<MonthWidget> {
  @override
  void initState() {
    super.initState();
    // Fetch top bets on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(topBetsProvider.notifier).fetchTopBets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topBetsAsync = ref.watch(topBetsProvider);
    return SizedBox(
      height: 400, // Fixed height for the container
      child: topBetsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (topBetsModel) {
          if (topBetsModel == null || topBetsModel.data.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          // Filter bets to show only current month's bets
          final now = DateTime.now();
          final monthStart = DateTime(now.year, now.month, 1);
          final monthEnd = DateTime(now.year, now.month + 1, 1);

          final currentMonthBets = topBetsModel.data.where((bet) {
            if (bet.createdAt == null) return false;
            try {
              final betDate = DateTime.parse(bet.createdAt!);
              return betDate.isAfter(
                    monthStart.subtract(const Duration(days: 1)),
                  ) &&
                  betDate.isBefore(monthEnd);
            } catch (e) {
              return false;
            }
          }).toList();

          if (currentMonthBets.isEmpty) {
            return const Center(child: Text('No bets for this month'));
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: false, // Allow scrolling within the container
            padding: EdgeInsets.zero,
            itemCount: currentMonthBets.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 6);
            },
            itemBuilder: (context, index) {
              final topBet = currentMonthBets[index];
              return Container(
                height: 71,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.aviatorSixthColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Container for avatar
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.aviatorTertiaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        SizedBox(height: 2),
                        //User name
                        Text(
                          topBet.userId?.userName ?? '',
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorBodyLargePrimary,
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Cash out:  ',
                              style: Theme.of(
                                context,
                              ).textTheme.aviatorBodyMediumSecondary,
                            ),
                            //! container for cash out- 10000
                            Container(
                              height: 24,
                              width: 73,
                              padding: const EdgeInsets.only(
                                top: 4,
                                bottom: 4,
                                left: 2,
                                right: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.aviatorTwentyFifthColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  topBet.cashoutAt.toString(),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.aviatorbodySmallPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '         Win:  ',
                              style: Theme.of(
                                context,
                              ).textTheme.aviatorBodyMediumSecondary,
                            ),
                            //! container for win- 10000
                            Container(
                              height: 24,
                              width: 73,
                              padding: const EdgeInsets.only(
                                top: 4,
                                bottom: 4,
                                left: 2,
                                right: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.aviatorTwentiethColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  topBet.payout.toString(),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.aviatorbodySmallPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
