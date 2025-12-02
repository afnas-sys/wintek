import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/auth/providers/secure_storage_provider.dart';
import 'package:wintek/features/game/crash/service/crash_recent_rounds_service.dart';

final crashRecentRoundsServiceProvider = Provider<CrashRecentRoundsService>((
  ref,
) {
  return CrashRecentRoundsService(
    ref.watch(dioProvider),
    ref.watch(secureStorageServiceProvider),
  );
});
