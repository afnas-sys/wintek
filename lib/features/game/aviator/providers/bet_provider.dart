import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/game/aviator/domain/models/bet_request.dart';
import 'package:wintek/features/game/aviator/service/bet_api_service.dart';

// // Provide Dio instance
// final dioProvider = Provider<Dio>((ref) {
//   return Dio(BaseOptions(
//     baseUrl: "https://ank143matkaapp.info/api/v1/",
//     connectTimeout: const Duration(seconds: 10),
//     receiveTimeout: const Duration(seconds: 10),
//   ));
// });

// Provide BetService

// StateNotifier for placing bets
final betServiceProvider = Provider((ref) => BetService(ref.read(dioProvider)));

class BetNotifier extends StateNotifier<AsyncValue<void>> {
  final BetService betService;
  BetNotifier(this.betService) : super(const AsyncValue.data(null));

  Future<void> placeBet(BetRequest bet) async {
    log('bet function called');
    state = const AsyncValue.loading();
    try {
      final response = await betService.placeBet(bet);
      log('Bet response: $response');
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Provider for BetNotifier
final betNotifierProvider =
    StateNotifierProvider<BetNotifier, AsyncValue<void>>((ref) {
      final betService = ref.watch(betServiceProvider);
      return BetNotifier(betService);
    });
