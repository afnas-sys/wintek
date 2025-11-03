import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/payment/domain/models/user_transaction_response_model.dart';
import 'package:wintek/core/network/dio_provider.dart';

class UserTransactionService {
  final Dio dio;

  UserTransactionService(this.dio);

  Future<UserTransactionResponseModel> getUserTransactions(
    int skip,
    int count,
  ) async {
    final userData = await SecureStorageService().readCredentials();

    try {
      final response = await dio.get(
        'app/transaction/get',
        queryParameters: {
          'user_id': userData.userId,
          'skip': skip,
          'count': count,
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${userData.token}'},
        ),
      );
      return UserTransactionResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      log('User Transaction API error: ${e.response?.data ?? e.message}');
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
    }
  }
}

final userTransactionServiceProvider = Provider<UserTransactionService>((ref) {
  return UserTransactionService(ref.read(dioProvider));
});
