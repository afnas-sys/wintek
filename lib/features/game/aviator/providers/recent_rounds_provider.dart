import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/game/aviator/service/recent_rounds_service.dart';

final recentRoundsServiceProvider = Provider<RecentRoundsService>((ref) {
  return RecentRoundsService(ref.watch(dioProvider));
});
