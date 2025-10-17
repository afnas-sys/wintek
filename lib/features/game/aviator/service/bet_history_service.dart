import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/aviator/domain/models/my_bets_model.dart';

class BetHistoryService {
  final Dio dio;
  final SecureStorageService storageService;

  BetHistoryService(this.dio, this.storageService);

  Future<MyBetsModel?> fetchBetHistory({int page = 1, int limit = 50}) async {
    try {
      // Read userId from secure storage
      final credentials = await storageService.readCredentials();
      final userId = credentials.userId;

      if (userId == null) {
        log('❌ UserId not found in storage');
        return null;
      }

      final response = await dio.get(
        'app/aviator/bets/history/user/$userId',
        queryParameters: {'limit': limit, 'page': page},
      );

      log('✅ Bet History API success: ${response.data}');

      return MyBetsModel.fromJson(response.data);
    } on DioException catch (e) {
      log('❌ DioException: ${e.message}');
      log('👉 Request path: ${e.requestOptions.path}');
      log('👉 Request headers: ${e.requestOptions.headers}');
      log('👉 Request query: ${e.requestOptions.queryParameters}');
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
