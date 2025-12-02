import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/crash/domain/models/crash_my_bets_model.dart';

class CrashMyBetsHistoryService {
  final Dio dio;
  final SecureStorageService storageService;

  CrashMyBetsHistoryService(this.dio, this.storageService);

  Future<CrashMyBetsModel?> fetchUser({int limit = 50, int page = 1}) async {
    try {
      final credentials = await storageService.readCredentials();
      final userId = credentials.userId;
      final response = await dio.get(
        'app/crash/bets/history/user/$userId',
        queryParameters: {'limit': limit, 'page': page},
      );

      log('✅ Crash User API success: ${response.data}');

      return CrashMyBetsModel.fromJson(response.data);
    } on DioException catch (e) {
      log('❌ DioException: ${e.message}');
      log('👉 Request path: ${e.requestOptions.path}');
      log('👉 Request headers: ${e.requestOptions.headers}');
      if (e.response != null) {
        log('👉 Response status: ${e.response?.statusCode}');
        log('👉 Response data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      log('⚠️ Unknown error: $e');
      rethrow;
    }
  }
}
