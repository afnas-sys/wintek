import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/withdraw_service.dart';
import 'package:wintek/core/network/dio_provider.dart';

final withdrawServicesProvider = Provider<WithdrawService>((ref) {
  return WithdrawService(ref.read(dioProvider));
});
