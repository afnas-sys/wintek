import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/game/aviator/providers/bet_history_provider.dart';
import 'package:wintek/features/game/crash/domain/models/crash_my_bets_model.dart';
import 'package:wintek/features/game/crash/service/crash_my_bets_history_service.dart';

class CrashMyBetsNotifier extends StateNotifier<AsyncValue<CrashMyBetsModel?>> {
  final CrashMyBetsHistoryService _myBetsHistoryService;
  int _currentPage = 1;

  CrashMyBetsNotifier(this._myBetsHistoryService)
    : super(const AsyncValue.loading());

  int get currentPage => _currentPage;

  Future<void> fetchMyBetsHistory({int limit = 50, int page = 1}) async {
    state = const AsyncValue.loading();
    try {
      _currentPage = page;
      final result = await _myBetsHistoryService.fetchUser(
        limit: limit,
        page: page,
      );
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final crashMyBetsHistoryServiceProvider = Provider<CrashMyBetsHistoryService>((
  ref,
) {
  return CrashMyBetsHistoryService(
    ref.watch(dioProvider),
    ref.watch(secureStorageProvider), // Inject storage service
  );
});

final crashMyBetsHistoryProvider =
    StateNotifierProvider<CrashMyBetsNotifier, AsyncValue<CrashMyBetsModel?>>(
      (ref) =>
          CrashMyBetsNotifier(ref.watch(crashMyBetsHistoryServiceProvider)),
    );
