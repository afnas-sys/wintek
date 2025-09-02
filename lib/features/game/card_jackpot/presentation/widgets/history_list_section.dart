import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/game_history_tile.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/my_history_tile.dart';
import 'package:wintek/features/game/card_jackpot/providers/game_round/game_round_provider.dart';

class HistoryListSection extends ConsumerWidget {
  final bool isGameHistory;
  const HistoryListSection({super.key, this.isGameHistory = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRounds = ref.watch(betProvider);
    final gameHistories = allRounds
        .where((round) => round.status != 'pending')
        .toList();

    final displayList = (isGameHistory ? gameHistories : allRounds).reversed
        .toList();

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 12),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: displayList.length,
      separatorBuilder: (context, index) => Divider(color: Color(0x1A202020)),
      itemBuilder: (context, index) {
        final round = displayList[index];
        return isGameHistory
            ? GameHistoryTile(bet: round)
            : MyHistoryTile(bet: round);
      },
    );
  }
}
