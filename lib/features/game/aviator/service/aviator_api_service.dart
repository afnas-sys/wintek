import 'package:dio/dio.dart';
import 'package:wintek/core/constants/api_constants/api_constants.dart';
import 'package:wintek/features/game/aviator/domain/constants/aviator_api_constants.dart';
import 'package:wintek/features/game/aviator/domain/models/aviator_round.dart';

class AviatorApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: ApiContants.baseUrl));

  Future<AviatorRound?> getCurrentRound() async {
    try {
      final res = await dio.get(AviatorApiConstants.currentRound);
      return AviatorRound.fromJson(res.data);
    } catch (e) {
      rethrow;
    }
  }
}
