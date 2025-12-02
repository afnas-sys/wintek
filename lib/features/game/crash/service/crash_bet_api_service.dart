import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/crash/domain/constants/crash_api_constants.dart';
import 'package:wintek/features/game/crash/domain/models/crash_bet_request_model.dart';
import 'package:wintek/features/game/crash/domain/models/crash_bet_response_model.dart';

class CrashBetApiService {
  final Dio dio;
  final SecureStorageService storageService = SecureStorageService();

  CrashBetApiService(this.dio);

  Future<CrashBetResponseModel?> placeBet(CrashBetRequestModel request) async {
    try {
      final credentials = await storageService.readCredentials();
      final token = credentials.token;
      final response = await dio.post(
        CrashApiConstants.bet,
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      log('✅ Crash Bet API success: ${(response.data)}');

      return CrashBetResponseModel.fromJson(response.data['bet']);
    } on DioException catch (e) {
      log('❌ DioException: ${e.message}');
      log('👉 Request path: ${e.requestOptions.path}');
      log('👉 Request headers: ${e.requestOptions.headers}');
      log('👉 Request body: ${e.requestOptions.data}');
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
