import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wintek/features/game/aviator/domain/constants/aviator_api_constants.dart';
import 'package:wintek/features/game/aviator/domain/models/bet_request.dart';
import 'package:wintek/features/game/aviator/domain/models/bet_response.dart';

class BetApiService {
  final Dio dio;

  BetApiService(this.dio);

  Future<BetResponse?> placeBet(BetRequest request) async {
    try {
      final response = await dio.post(
        AviatorApiConstants.bet,
        data: request.toJson(),
      );

      log('✅ Bet API success: ${(response.data)}');

      return BetResponse.fromJson(response.data['bet']);
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
