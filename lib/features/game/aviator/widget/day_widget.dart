import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/game/aviator/providers/top_bets_provider.dart';

class DayWidget extends ConsumerStatefulWidget {
  const DayWidget({super.key});

  @override
  ConsumerState<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends ConsumerState<DayWidget> {
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

          // Filter bets to show only today's bets
          final today = DateTime.now();
          final todayStart = DateTime(today.year, today.month, today.day);
          final todayEnd = todayStart.add(const Duration(days: 1));

          final todaysBets = topBetsModel.data.where((bet) {
            if (bet.createdAt == null) return false;
            try {
              final betDate = DateTime.parse(bet.createdAt!);
              return betDate.isAfter(todayStart) && betDate.isBefore(todayEnd);
            } catch (e) {
              return false;
            }
          }).toList();

          if (todaysBets.isEmpty) {
            return const Center(child: Text('No bets for today'));
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: false, // Allow scrolling within the container
            //  clipBehavior: Clip.none,
            padding: EdgeInsets.zero,
            itemCount: todaysBets.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 6);
            },
            itemBuilder: (context, index) {
              final topBet = todaysBets[index];
              String formatNum(num? value) =>
                  value?.toStringAsFixed(2) ?? '0.00';
              return Container(
                height: 71,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.aviatorSixthColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.aviatorFifteenthColor),
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
                            //! container for cash out- 100
                            Container(
                              height: 24,
                              width: 73,
                              padding: const EdgeInsets.only(
                                top: 4,
                                bottom: 4,
                                left: 8,
                                right: 8,
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
                            //! container for win- 100
                            Container(
                              height: 24,
                              width: 73,
                              padding: const EdgeInsets.only(
                                top: 4,
                                bottom: 4,
                                left: 8,
                                right: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.aviatorTwentiethColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  formatNum(topBet.payout),
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
