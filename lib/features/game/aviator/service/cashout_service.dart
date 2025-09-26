import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wintek/features/game/aviator/domain/models/cashout_response.dart';

class CashoutService {
  final Dio dio;
  CashoutService(this.dio);

  Future<CashoutResponse> cashout({
    required String id,
    required double cashOutAt,
  }) async {
    try {
      final response = await dio.post(
        "app/aviator/bets/$id/cashout",
        data: {"cashOutAt": cashOutAt},
      );
      log('✅ Cashout API success: ${(response.data)}');
      return CashoutResponse.fromJson(response.data);
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
