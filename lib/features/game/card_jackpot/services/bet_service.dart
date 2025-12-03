import 'package:dio/dio.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/card_jackpot/domain/constants/api_constants.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/bet_request_model.dart';

class BetService {
  final Dio dio;
  final secureStorageService = SecureStorageService();
  BetService(this.dio);

  Future<Map<String, dynamic>?> placeBet(BetRequestModel betRequest) async {
    final secureData = await SecureStorageService().readCredentials();

    try {
      final res = await dio.post(
        CardApiConstants.placeBet,
        options: Options(
          headers: {'Authorization': 'Bearer ${secureData.token}'},
        ),
        data: betRequest.toJson(),
      );
      return res.data;
    } on DioException catch (e) {
      // Return error details for proper handling
      return {
        'error': true,
        'message':
            e.response?.data?['message'] ??
            'Failed to place bet. Please try again.',
        'statusCode': e.response?.statusCode ?? 0,
      };
    } catch (e) {
      return {
        'error': true,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }
}
