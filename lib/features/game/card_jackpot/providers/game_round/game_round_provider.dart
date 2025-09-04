import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/domain/game_round/round_model.dart';

final betProvider = StateNotifierProvider<BetNotifier, List<BetModel>>(
  (ref) => BetNotifier(ref),
);
final currentBetProvider = StateProvider<BetModel?>((ref) => null);

final currentBetIdProvider = StateProvider<String>((ref) => '');

class BetNotifier extends StateNotifier<List<BetModel>> {
  final Ref ref;
  BetNotifier(this.ref) : super([]);

  void createNewRound() {
    final millisecond = DateTime.now().millisecondsSinceEpoch.toString();
    final newBetId = millisecond.substring(millisecond.length - 7);
    ref.read(currentBetIdProvider.notifier).state = newBetId;
    final betRound = BetModel(id: newBetId);
    ref.read(currentBetProvider.notifier).state = betRound;
  }

  void addRound({String? cardName, num? amount}) {
    final current = ref.read(currentBetProvider);
    if (current == null) return;

    final confirmed = current.copyWith(
      cardName: cardName,
      betTime: DateTime.now(),
      amount: amount,
      status: "pending",
    );

    state = [...state, confirmed];
  }

  void updateStatus() {
    final current = ref.read(currentBetProvider);
    final id = current?.id;
    if (current == null) return;

    state = [
      for (final round in state)
        if (round.id == id) round.copyWith(status: 'failed') else round,
    ];
  }
}
