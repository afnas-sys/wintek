import 'package:dio/dio.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/card_jackpot/domain/constants/api_constants.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/bet_request_model.dart';

class BetService {
  final Dio dio;
  final secureStorageService = SecureStorageService();
  BetService(this.dio);

  Future<Map<String, dynamic>?> placeBet(BetRequestModel betRequest) async {
    try {
      final res = await dio.post(
        CardApiConstants.placeBet,
        data: betRequest.toJson(),
      );
      return res.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {}
      return null;
    } catch (e) {
      return null;
    }
  }
}
