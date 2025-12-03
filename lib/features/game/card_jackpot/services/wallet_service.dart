import 'package:dio/dio.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/card_jackpot/domain/constants/api_constants.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/wallet_responce.dart';

class WalletService {
  final Dio dio;
  final secureStorageService = SecureStorageService();
  WalletService(this.dio);

  Future<WalletResponse?> getWalletBalance() async {
    final storageData = await secureStorageService.readCredentials();
    try {
      final res = await dio.get(
        '${CardApiConstants.getWalletBalance}${storageData.userId}',
        options: Options(
          headers: {'Authorization': 'Bearer ${storageData.token}'},
        ),
      );
      return WalletResponse.fromJson(res.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
      } else if (e.type == DioExceptionType.badResponse) {
      } else {}
      return null;
    } catch (e) {
      return null;
    }
  }
}
