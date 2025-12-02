import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/game/crash/service/crash_cashout_service.dart';

final crashCashoutServiceProvider = Provider<CrashCashoutService>((ref) {
  return CrashCashoutService(ref.watch(dioProvider));
});
