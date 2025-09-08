import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/providers/dio_provider.dart';

class ApiServices {
  final Dio dio;

  ApiServices(this.dio);

  //!SignUp
  Future<Map<String, dynamic>> signup({
    required String name,
    required String mobile,
    required String password,
    //  String? email,
    String? referralCode,
  }) async {
    try {
      final response = await dio.post(
        'auth/signup',
        data: {
          'user_name': name,
          'mobile': mobile,
          //  'email': email ?? '',
          'password': password,
          'referral_code': referralCode ?? '',
          'fcm': '_',
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
    }
  }

  //!Send otp
  Future<Map<String, dynamic>> sendOtp(String mobile) async {
    try {
      final response = await dio.post('auth/send', data: {'mobile': mobile});
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
    }
  }

  //! otp verify
  Future<Map<String, dynamic>> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    try {
      final response = await dio.post(
        'auth/verify',
        data: {'mobile': mobile, 'otp': otp},
      );
      log('TOKEN: ${response.data['tokenData']['token']}');
      log('EXPIRES IN: ${response.data['tokenData']['expiresIn']}');
      log('COOKIE: ${response.data['cookie'].toString()}');
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
    }
  }

  //! Log in
  Future<Map<String, dynamic>> login({
    required String mobile,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        'auth/loginmobile',
        data: {'mobile': mobile, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
    }
  }

  //! Forgotten pass
  Future<Map<String, dynamic>> forgottenPass({
    required String mobile,
    required String password,
    required String otp,
  }) async {
    try {
      final response = await dio.post(
        'auth/forgotpass',
        data: {'mobile': mobile, 'password': password, 'otp': otp},
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
    }
  }
}

final authrepositoryProvider = Provider<ApiServices>((ref) {
  return ApiServices(ref.read(dioProvider));
});
