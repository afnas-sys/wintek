import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/services/history_service.dart';

final myHistoryProvider =
    StateNotifierProvider<
      MyHistoryNotifier,
      AsyncValue<List<Map<String, dynamic>>>
    >((ref) {
      final historyService = ref.watch(historyServiceProvider);
      return MyHistoryNotifier(historyService);
    });

final gameHistoryProvider =
    StateNotifierProvider<
      GameHistoryNotifier,
      AsyncValue<List<Map<String, dynamic>>>
    >((ref) {
      final historyService = ref.watch(historyServiceProvider);
      return GameHistoryNotifier(historyService);
    });

class MyHistoryNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final HistoryService _historyService;

  MyHistoryNotifier(this._historyService) : super(const AsyncValue.loading()) {
    fetchMyHistory();
  }

  Future<void> fetchMyHistory() async {
    state = const AsyncValue.loading();
    try {
      final data = await _historyService.fetchMyHistory();
      state = AsyncValue.data(data);
    } catch (e) {
      // Keep loading state on error
      state = const AsyncValue.loading();
    }
  }
}

class GameHistoryNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final HistoryService _historyService;

  GameHistoryNotifier(this._historyService)
    : super(const AsyncValue.loading()) {
    fetchGameHistory();
  }

  Future<void> fetchGameHistory() async {
    state = const AsyncValue.loading();
    try {
      final data = await _historyService.fetchGameHistory();
      state = AsyncValue.data(data);
    } catch (e) {
      // Keep loading state on error
      state = const AsyncValue.loading();
    }
  }
}
