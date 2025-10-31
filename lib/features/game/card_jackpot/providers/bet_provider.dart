import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_strings.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/bet_request_model.dart';
import 'package:wintek/features/game/card_jackpot/providers/history_provider.dart';
import 'package:wintek/features/game/card_jackpot/providers/wallet_provider.dart';
import 'package:wintek/features/game/card_jackpot/services/bet_service.dart';

class BetNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final BetService _betService;
  final Ref _ref;

  BetNotifier(this._betService, this._ref) : super(const AsyncValue.data(null));

  Future<void> placeBet({
    required String cardName,
    required int amount,
    required String sessionId,
    required String roundId,
    required int cardTypeIndex,
  }) async {
    state = const AsyncValue.loading();
    try {
      final secureData = await SecureStorageService().readCredentials();
      final suitName = AppStrings.mainCardTypeNames[cardTypeIndex]
          .toLowerCase();
      final cardValue = cardName.toString().toLowerCase();
      final formattedCardName = '$suitName-$cardValue';
      final betRequest = BetRequestModel(
        roundId: roundId,
        userId: secureData.userId!,
        sessionId: sessionId,
        points: amount,
        cardNumber: formattedCardName,
      );

      final result = await _betService.placeBet(betRequest);
      if (result != null) {
        state = AsyncValue.data(result);
        log('Bet placed successfully');
        // Refresh wallet balance after successful bet
        _ref.invalidate(walletBalanceProvider);
        // Auto refresh history after successful bet
        _ref.invalidate(myHistoryProvider);
      } else {
        state = AsyncValue.error('Failed to place bet', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      log('Error placing bet: $e');
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final betServiceProvider = Provider<BetService>((ref) {
  final dio = ref.watch(dioProvider);
  return BetService(dio);
});

final betNotifierProvider =
    StateNotifierProvider<BetNotifier, AsyncValue<Map<String, dynamic>?>>((
      ref,
    ) {
      final betService = ref.watch(betServiceProvider);
      return BetNotifier(betService, ref);
    });
