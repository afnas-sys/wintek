import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/game_history_tile.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/my_history_tile.dart';
import 'package:wintek/features/game/card_jackpot/providers/history_provider.dart';

class HistoryListSection extends ConsumerWidget {
  final bool isGameHistory;
  const HistoryListSection({super.key, this.isGameHistory = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isGameHistory) {
      final gameHistoryAsync = ref.watch(gameHistoryProvider);
      return gameHistoryAsync.when(
        data: (data) => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: data.length,
          separatorBuilder: (context, index) =>
              const Divider(color: Color(0x1A202020)),
          itemBuilder: (context, index) {
            final item = data[index];
            return GameHistoryTile(
              period: item['period'] ?? '',
              result: item['result'] ?? '',
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      );
    } else {
      final myHistoryAsync = ref.watch(myHistoryProvider);
      return myHistoryAsync.when(
        data: (data) => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: data.length,
          separatorBuilder: (context, index) =>
              const Divider(color: Color(0x1A202020)),
          itemBuilder: (context, index) {
            final item = data[index];
            return MyHistoryTile(
              bet: item, // Assuming MyHistoryTile expects a Map
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      );
    }
  }
}
