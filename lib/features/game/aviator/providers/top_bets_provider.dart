import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/game/aviator/domain/models/top_bets_model.dart';
import 'package:wintek/features/game/aviator/service/top_bets_service.dart';

class TopBetsNotifier extends StateNotifier<AsyncValue<TopBetsModel?>> {
  final TopBetsService _topBetsService;

  TopBetsNotifier(this._topBetsService) : super(const AsyncValue.loading());

  Future<void> fetchTopBets({int limit = 50, int page = 1}) async {
    state = const AsyncValue.loading();
    try {
      final result = await _topBetsService.fetchTopBets(
        limit: limit,
        page: page,
      );
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final topBetsServiceProvider = Provider<TopBetsService>((ref) {
  return TopBetsService(ref.watch(dioProvider));
});

final topBetsProvider =
    StateNotifierProvider<TopBetsNotifier, AsyncValue<TopBetsModel?>>(
      (ref) => TopBetsNotifier(ref.watch(topBetsServiceProvider)),
    );
