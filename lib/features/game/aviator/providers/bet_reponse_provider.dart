import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/aviator/domain/models/bet_response.dart';

class BetResponseNotifier extends StateNotifier<Map<int, BetResponse?>> {
  // Using a map to track bets by index (0,1,2,...)
  BetResponseNotifier() : super({});

  void setBetResponse(int index, BetResponse response) {
    state = {...state, index: response};
  }

  void clearBetResponse(int index) {
    final newState = {...state};
    newState.remove(index);
    state = newState;
  }

  BetResponse? getBetResponse(int index) => state[index];
}

final betResponseProvider =
    StateNotifierProvider<BetResponseNotifier, Map<int, BetResponse?>>(
      (ref) => BetResponseNotifier(),
    );
