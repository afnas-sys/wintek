import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/payment/deposit/domain/models/deposit_request_model.dart';
import 'package:wintek/features/payment/domain/models/transfer_response_model.dart';
import 'package:wintek/core/network/dio_provider.dart';

class DepositServices {
  final Dio dio;

  DepositServices(this.dio);

  Future<TransferResponseModel> createTransaction(
    DepositRequestModel request,
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

final depositServicesProvider = Provider<DepositServices>((ref) {
  return DepositServices(ref.read(dioProvider));
});
