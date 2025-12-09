import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/wallet_responce.dart';
import 'package:wintek/features/game/card_jackpot/services/wallet_service.dart';

class WalletNotifier extends StateNotifier<AsyncValue<WalletResponse?>> {
  final WalletService _walletService;

  WalletNotifier(this._walletService)
    : super(const AsyncLoading<WalletResponse?>()) {
    fetchWalletBalance();
  }

  Future<void> fetchWalletBalance() async {
    try {
      final res = await _walletService.getWalletBalance();
      state = AsyncValue.data(res);
    } catch (e, s) {
      state = AsyncError<WalletResponse?>(e, s).copyWithPrevious(state);
    }
  }

  void updateBalance(double newBalance) {
    // Update state immediately with new balance
    final currentData = state.valueOrNull;
    if (currentData != null) {
      state = AsyncValue.data(
        WalletResponse(
          success: currentData.success,
          message: currentData.message,
          data: WalletData(balance: newBalance),
        ),
      );
    } else {
      // If we don't have base structure, fetch full object
      fetchWalletBalance();
    }
  }
}

final walletBalanceProvider =
    StateNotifierProvider<WalletNotifier, AsyncValue<WalletResponse?>>((ref) {
      final walletService = WalletService(ref.read(dioProvider));
      return WalletNotifier(walletService);
    });
