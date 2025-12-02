import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/crash/domain/models/crash_bet_response_model.dart';

class CrashBetResponseNotifier
    extends StateNotifier<Map<int, CrashBetResponseModel?>> {
  // Using a map to track bets by index (0,1,2,...)
  CrashBetResponseNotifier() : super({});

  void setBetResponse(int index, CrashBetResponseModel? response) {
    state = {...state, index: response};
  }

  void clearBetResponse(int index) {
    final newState = {...state};
    newState.remove(index);
    state = newState;
  }

  CrashBetResponseModel? getBetResponse(int index) => state[index];
}

final crashBetResponseProvider =
    StateNotifierProvider<
      CrashBetResponseNotifier,
      Map<int, CrashBetResponseModel?>
    >((ref) => CrashBetResponseNotifier());
