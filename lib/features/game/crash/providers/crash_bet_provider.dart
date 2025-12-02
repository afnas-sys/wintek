import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/game/crash/service/crash_bet_api_service.dart';

enum CrashBetStatus { none, placed }

class CrashBetStateNotifier extends StateNotifier<Map<int, CrashBetStatus>> {
  CrashBetStateNotifier() : super({});

  CrashBetStatus getStatus(int index) => state[index] ?? CrashBetStatus.none;

  void placeBet(int index) {
    state = {...state, index: CrashBetStatus.placed};
  }

  void cancelBet(int index) {
    state = {...state, index: CrashBetStatus.none};
  }
}

// Provider
final crashBetStateProvider =
    StateNotifierProvider<CrashBetStateNotifier, Map<int, CrashBetStatus>>(
      (ref) => CrashBetStateNotifier(),
    );
final crashBetServiceProvider = Provider<CrashBetApiService>((ref) {
  return CrashBetApiService(ref.watch(dioProvider));
});
