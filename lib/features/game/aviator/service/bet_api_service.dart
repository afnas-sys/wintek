import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wintek/features/game/aviator/domain/models/bet_request.dart';

class BetService {
  final Dio dio;

  BetService(this.dio);

  Future<Response> placeBet(BetRequest bet) async {
    log('Sending bet: ${bet.toJson()}');
    final response = await dio.post('app/aviator/bets', data: bet.toJson());
    log('Raw response: ${response.data}');
    return response;
  }
}
