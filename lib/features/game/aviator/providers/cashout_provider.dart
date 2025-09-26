import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/game/aviator/service/cashout_service.dart';

final cashoutServiceProvider = Provider<CashoutService>((ref) {
  return CashoutService(ref.watch(dioProvider));
});
