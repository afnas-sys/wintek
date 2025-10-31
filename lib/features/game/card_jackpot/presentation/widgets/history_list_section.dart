import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/game_history_tile.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/my_history_tile.dart';
import 'package:wintek/features/game/card_jackpot/providers/history_provider.dart';

class HistoryListSection extends ConsumerWidget {
  final bool isGameHistory;
  const HistoryListSection({super.key, this.isGameHistory = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameHistoryAsync = ref.watch(gameHistoryProvider);
    final myHistoryAsync = ref.watch(myHistoryProvider);

    return (isGameHistory ? gameHistoryAsync : myHistoryAsync).when(
      data: (data) => ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shrinkWrap: true,
        physics: const ScrollPhysics(),
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
