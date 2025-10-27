import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/aviator/domain/models/user_model.dart';

class UserService {
  final Dio dio;
  final SecureStorageService storageService = SecureStorageService();

  UserService(this.dio);

  Future<UserModel?> fetchUser() async {
    try {
      final credentials = await storageService.readCredentials();
      final userId = credentials.userId;
      final token = credentials.token;
      final response = await dio.get(
        'app/users/get/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      log('✅ User API success: ${response.data}');

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      log('❌ DioException: ${e.message}');
      log('👉 Request path: ${e.requestOptions.path}');
      log('👉 Request headers: ${e.requestOptions.headers}');
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
