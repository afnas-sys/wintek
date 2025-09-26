import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/game/aviator/service/bet_api_service.dart';

enum BetStatus { none, placed }

class BetStateNotifier extends StateNotifier<Map<int, BetStatus>> {
  BetStateNotifier() : super({});

  BetStatus getStatus(int index) => state[index] ?? BetStatus.none;

  void placeBet(int index) {
    state = {...state, index: BetStatus.placed};
  }

  void cancelBet(int index) {
    state = {...state, index: BetStatus.none};
  }
}

// Provider
final betStateProvider =
    StateNotifierProvider<BetStateNotifier, Map<int, BetStatus>>(
      (ref) => BetStateNotifier(),
    );
final betServiceProvider = Provider<BetApiService>((ref) {
  return BetApiService(ref.watch(dioProvider));
});
