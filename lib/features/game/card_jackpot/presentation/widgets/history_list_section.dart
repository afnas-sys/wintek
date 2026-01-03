import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/game_history_tile.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/my_history_tile.dart';
import 'package:wintek/features/game/card_jackpot/providers/history_provider.dart';
import 'package:wintek/core/constants/app_colors.dart';

class HistoryListSection extends ConsumerWidget {
  final bool isGameHistory;
  const HistoryListSection({super.key, this.isGameHistory = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameHistoryAsync = ref.watch(gameHistoryProvider);
    final myHistoryAsync = ref.watch(myHistoryProvider);

    final hasReachedMax = isGameHistory
        ? ref.watch(gameHistoryProvider.notifier).hasReachedMax
        : ref.watch(myHistoryProvider.notifier).hasReachedMax;

    return (isGameHistory ? gameHistoryAsync : myHistoryAsync).when(
      data: (data) => Column(
        children: [
          ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (context, index) => _buildDivider(),
            itemBuilder: (context, index) {
              final item = data[index];
              if (isGameHistory) {
                return GameHistoryTile(
                  period: item['sessionId'] ?? '',
                  result: item['winningCard'] ?? '',
                );
              } else {
                return MyHistoryTile(bet: item);
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!hasReachedMax)
                  Flexible(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cardPrimaryColor,
                        foregroundColor: AppColors.cardSecondPrimaryColor,
                        side: const BorderSide(
                          color: AppColors.gameTabContainerBorderColor,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (isGameHistory) {
                          ref
                              .read(gameHistoryProvider.notifier)
                              .fetchGameHistory();
                        } else {
                          ref.read(myHistoryProvider.notifier).fetchMyHistory();
                        }
                      },
                      child:
                          (isGameHistory
                              ? ref
                                    .watch(gameHistoryProvider.notifier)
                                    .isFetchingMore
                              : ref
                                    .watch(myHistoryProvider.notifier)
                                    .isFetchingMore)
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.arrow_downward, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Load More',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                if (data.length > (isGameHistory ? 20 : 10)) ...[
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardPrimaryColor,
                      foregroundColor: AppColors.cardSecondPrimaryColor,
                      side: const BorderSide(
                        color: AppColors.gameTabContainerBorderColor,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // Scroll to top of the history section
                      Scrollable.ensureVisible(
                        context,
                        alignment: 0.0,
                        duration: const Duration(milliseconds: 500),
                      );
                      // Reset data to Page 1 to free memory
                      if (isGameHistory) {
                        ref
                            .read(gameHistoryProvider.notifier)
                            .fetchGameHistory(isRefresh: true);
                      } else {
                        ref
                            .read(myHistoryProvider.notifier)
                            .fetchMyHistory(isRefresh: true);
                      }
                    },
                    child: const Icon(Icons.arrow_upward),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      loading: () => ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (context, index) => _buildDivider(),
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              title: Container(height: 16, width: 100, color: Colors.white),
              trailing: SizedBox(
                width: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 3,
                  children: [
                    Container(width: 18, height: 18, color: Colors.white),
                    const SizedBox(width: 4),
                    Container(height: 16, width: 20, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error loading history: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: const Divider(color: Color.fromARGB(26, 83, 83, 83)),
    );
  }
}
