import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/card_jackpot/domain/constants/api_constants.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/responces/wallet_responce.dart';

class WalletService {
  final Dio dio;
  final secureStorageService = SecureStorageService();
  WalletService(this.dio);

  Future<WalletResponse?> getWalletBalance() async {
    final storageData = await secureStorageService.readCredentials();
    try {
      final res = await dio.get(
        '${CardApiConstants.getWalletBalance}${storageData.userId}',
      );
      log('response:  ${res.data}');
      return WalletResponse.fromJson(res.data);
    } on DioException catch (e) {
      // Dio-specific error
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        log('⏳ Connection timeout when fetching wallet balance');
      } else if (e.type == DioExceptionType.badResponse) {
        log('❌ Server error: ${e.response?.statusCode} -> ${e.response?.data}');
      } else {
        log('⚠️ Dio error: ${e.message}');
      }
      return null; // Or throw custom exception
    } catch (e, st) {
      // Any other error
      log('❌ Unexpected error while fetching wallet balance: $e\n$st');
      return null;
    }
  }
}
