import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/wallet_responce.dart';
import 'package:wintek/features/game/card_jackpot/services/wallet_service.dart';

final walletBalanceProvider = FutureProvider<WalletResponse?>((ref) async {
  final walletService = WalletService(ref.read(dioProvider));
  final wallet = await walletService.getWalletBalance();

  return wallet;
});
