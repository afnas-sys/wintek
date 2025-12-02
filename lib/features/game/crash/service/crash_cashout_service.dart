import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wintek/features/game/crash/domain/models/crash_cashout_response_model.dart';

class CrashCashoutService {
  final Dio dio;
  CrashCashoutService(this.dio);

  Future<CrashCashoutResponseModel> cashout({
    required String id,
    required double cashOutAt,
  }) async {
    log('🔍 Crash Cashout service: id=$id, cashOutAt=$cashOutAt');
    try {
      final requestData = {"cashoutAt": cashOutAt.toString()};
      log('📤 Sending data: $requestData');
      final response = await dio.post(
        "app/crash/bets/$id/cashout",
        data: requestData,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      log('✅ Crash Cashout API success: ${(response.data)}');
      return CrashCashoutResponseModel.fromJson(response.data['bet']);
    } on DioException catch (e) {
      log('👉 Response status: ${e.response?.statusCode}');
      log('👉 Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log('⚠️ Unknown error: $e');
      rethrow;
    }
  }
}
