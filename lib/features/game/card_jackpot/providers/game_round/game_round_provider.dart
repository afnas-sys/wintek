import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/domain/game_round/round_model.dart';

final betProvider = StateNotifierProvider<BetNotifier, List<BetModel>>(
  (ref) => BetNotifier(ref),
);
// final currentRoundIdProvider = StateProvider<String>((ref) => '');
final currentBetProvider = StateProvider<BetModel?>((ref) => null);

class BetNotifier extends StateNotifier<List<BetModel>> {
  final Ref ref;
  BetNotifier(this.ref) : super([]);

  void createNewRound() {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final currentRoundId = newId.substring(newId.length - 7);
    final betRound = BetModel(id: currentRoundId);
    // ref.read(currentRoundIdProvider.notifier).state = currentRoundId;
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

  /// change status when the time ends to sucess or failed
  void updateStatus() {
    final current = ref.read(currentBetProvider);
    final id = current?.id;
    if (current == null) return;

    state = [
      for (final round in state)
        if (round.id == id) round.copyWith(status: 'success') else round,
    ];
  }
}
