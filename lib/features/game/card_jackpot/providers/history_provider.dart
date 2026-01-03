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
  int _currentPage = 1;
  bool _hasReachedMax = false;
  bool _isFetchingMore = false;

  MyHistoryNotifier(this._historyService) : super(const AsyncValue.loading()) {
    fetchMyHistory();
  }

  Future<void> fetchMyHistory({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasReachedMax = false;
    }

    if (_hasReachedMax || _isFetchingMore) return;

    if (_currentPage == 1) {
      state = const AsyncValue.loading();
    } else {
      _isFetchingMore = true;
    }

    try {
      final newData = await _historyService.fetchMyHistory(
        page: _currentPage,
        limit: 10,
      );

      if (newData.isEmpty || newData.length < 10) {
        _hasReachedMax = true;
      }

      final currentData = state.value ?? [];
      if (_currentPage == 1) {
        state = AsyncValue.data(newData);
      } else {
        state = AsyncValue.data([...currentData, ...newData]);
      }

      _currentPage++;
    } catch (e, stack) {
      if (_currentPage == 1) {
        state = AsyncValue.error(e, stack);
      }
    } finally {
      _isFetchingMore = false;
    }
  }

  bool get hasReachedMax => _hasReachedMax;
  bool get isFetchingMore => _isFetchingMore;
}

class GameHistoryNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final HistoryService _historyService;
  int _currentPage = 1;
  bool _hasReachedMax = false;
  bool _isFetchingMore = false;

  GameHistoryNotifier(this._historyService)
    : super(const AsyncValue.loading()) {
    fetchGameHistory();
  }

  Future<void> fetchGameHistory({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasReachedMax = false;
    }

    if (_hasReachedMax || _isFetchingMore) return;

    if (_currentPage == 1) {
      state = const AsyncValue.loading();
    } else {
      _isFetchingMore = true;
      // We need to notify listeners that isFetchingMore changed.
      // Since isFetchingMore is not part of the state, we might need to force a rebuild or use a different state structure.
      // For now, let's just use state = state to trigger listeners if needed,
      // but AsyncValue doesn't easily support "loading more" state without custom data.
    }

    try {
      final newData = await _historyService.fetchGameHistory(
        page: _currentPage,
        limit: 20,
      );

      if (newData.isEmpty || newData.length < 20) {
        _hasReachedMax = true;
      }

      final currentData = state.value ?? [];
      if (_currentPage == 1) {
        state = AsyncValue.data(newData);
      } else {
        state = AsyncValue.data([...currentData, ...newData]);
      }

      _currentPage++;
    } catch (e, stack) {
      if (_currentPage == 1) {
        state = AsyncValue.error(e, stack);
      }
    } finally {
      _isFetchingMore = false;
    }
  }

  bool get hasReachedMax => _hasReachedMax;
  bool get isFetchingMore => _isFetchingMore;
}
