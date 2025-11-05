import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/payment/domain/models/transfer_response_model.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/payment/withdraw/domain/models/withdraw_request_model.dart';

class WithdrawService {
  final Dio dio;

  WithdrawService(this.dio);

  Future<TransferResponseModel> createTransaction(
    WithdrawRequestModel request,
  ) async {
    final userData = await SecureStorageService().readCredentials();

    try {
      final response = await dio.post(
        'app/transaction/create',
        data: request.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer ${userData.token}'},
        ),
      );
      return TransferResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      log('Payment API error: ${e.response?.data ?? e.message}');
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
    }
  }
}

final withdrawServicesProvider = Provider<WithdrawService>((ref) {
  return WithdrawService(ref.read(dioProvider));
});
