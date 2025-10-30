import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/bet_result_event.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/event_model.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/round_end_event.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/round_new_event.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/round_state_event.dart';
import 'package:wintek/features/game/card_jackpot/services/card_socket_service.dart';

class CardRoundNotifier extends StateNotifier<RoundEvent> {
  CardRoundNotifier() : super(RoundEvent());

  void updateRoundState(RoundStateEvent event) {
    state = state.copyWith(
      roundId: event.roundId,
      state: event.state,
      sessionId: event.sessionId,
      msRemaining: event.msRemaining,
    );
  }

  void updateRoundNew(RoundNewEvent event) {
    state = state.copyWith(state: event.state, msRemaining: event.msRemaining);
  }

  void updateBetResult(BetResultEvent event) {
    state = state.copyWith(
      roundId: event.roundId,
      winningCard: event.winningCard,
      winners: event.winners,
      msRemaining: 0,
    );
  }

  void updateRoundEnd(RoundEndEvent event) {
    state = state.copyWith(
      state: event.state,
      winners: event.winners,
      winningCard: event.winningCard,
      msRemaining: 0,
    );
  }

  // void setBetting(bool value) {
  //   state = state.copyWith(isBetting: value);
  // }
}

//
//
//
//
//

// BettingNotifier provider (UI reads this state)
//
//
final cardRoundNotifierProvider =
    StateNotifierProvider<CardRoundNotifier, RoundEvent?>((ref) {
      return CardRoundNotifier();
    });
//
//
// Socket service provider
//
//
final cardSocketProvider = Provider<CardSocketService>((ref) {
  final notifier = ref.read(cardRoundNotifierProvider.notifier);
  final service = CardSocketService(notifier);

  service.connect();
  ref.onDispose(() => service.disconnect());

  return service;
});

//
//
// Current Bet Id Provider
//
//
final currentBetIdProvider = StateProvider<String>((ref) {
  final currentBetId = ref.watch(
    cardRoundNotifierProvider.select((value) => value?.sessionId),
  );
  return currentBetId.toString();
});
