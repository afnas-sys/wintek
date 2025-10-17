import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wintek/features/game/aviator/domain/models/top_bets_model.dart';

class TopBetsService {
  final Dio dio;

  TopBetsService(this.dio);

  Future<TopBetsModel?> fetchTopBets({int limit = 50, int page = 1}) async {
    try {
      final response = await dio.get(
        'app/aviator/bets/history/top-cashout',
        queryParameters: {'limit': limit, 'page': page},
      );

      log('✅ Top Bets API success: ${response.data}');

      return TopBetsModel.fromJson(response.data);
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
