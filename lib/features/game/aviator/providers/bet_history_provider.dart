import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/aviator/domain/models/my_bets_model.dart';
import 'package:wintek/features/game/aviator/service/bet_history_service.dart';

class BetHistoryNotifier extends StateNotifier<AsyncValue<MyBetsModel?>> {
  final BetHistoryService _betHistoryService;

  BetHistoryNotifier(this._betHistoryService)
    : super(const AsyncValue.loading());

  Future<void> fetchBetHistory({int page = 1, int limit = 50}) async {
    state = const AsyncValue.loading();
    try {
      final result = await _betHistoryService.fetchBetHistory(
        page: page,
        limit: limit,
      );
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final betHistoryServiceProvider = Provider<BetHistoryService>((ref) {
  return BetHistoryService(
    ref.watch(dioProvider),
    ref.watch(secureStorageProvider), // Inject storage service
  );
});

final betHistoryProvider =
    StateNotifierProvider<BetHistoryNotifier, AsyncValue<MyBetsModel?>>(
      (ref) => BetHistoryNotifier(ref.watch(betHistoryServiceProvider)),
    );
