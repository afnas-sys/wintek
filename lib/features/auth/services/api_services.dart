import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/domain/constants/api_constants.dart';
import 'package:wintek/features/auth/domain/model/forgot_password_model.dart';
import 'package:wintek/features/auth/domain/model/login_model.dart';
import 'package:wintek/features/auth/domain/model/register_model.dart';
import 'package:wintek/features/auth/domain/model/verify_otp_model.dart';
import 'package:wintek/features/auth/providers/dio_provider.dart';

class ApiServices {
  final Dio dio;

  ApiServices(this.dio);

  //!SignUp
  Future<Map<String, dynamic>> signup(RegisterRequestModel signupData) async {
    log('user data is ${signupData.name} ${signupData.mobile}');
    log(signupData.toJson().toString());

    try {
      final response = await dio.post(
        ApiConstants.signupAPI,
        data: signupData.toJson(),
        // Optionally: treat only network errors as exceptions
        options: Options(validateStatus: (status) => status! < 500),
      );

      // Now even 409 will come here instead of exception
      log('after signup api call ${response.data}');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e, st) {
      // If it's still an exception (like no internet)
      if (e.response != null && e.response?.data != null) {
        log('Dio error with response: ${e.response?.data}', stackTrace: st);
        return (e.response?.data as Map).cast<String, dynamic>();
      } else {
        log('Network error: ${e.message}', stackTrace: st);
        return {'status': 'failure', 'message': e.message ?? "Network error"};
      }
    } catch (e, st) {
      log('Unexpected signup error: $e', stackTrace: st);
      return {'status': 'failure', 'message': 'Unexpected error occurred'};
    }
  }

  //!Send otp
  Future<Map<String, dynamic>> sendOtp(String mobile) async {
    log('otp is sented to  $mobile');
    try {
      final response = await dio.post(
        ApiConstants.sentotpAPI,
        data: {'mobile': mobile},
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
    }
  }

  //! otp verify
  Future<VerifyOtpResponseModel> verifyOtp(
    VerifyOtpRequestModel otpRequestData,
  ) async {
    try {
      final response = await dio.post(
        ApiConstants.otpVerifyAPI,
        data: otpRequestData.toJson(),
      );

      return VerifyOtpResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
    }
  }

  //! Log in
  Future<LoginResponseModel> login(LoginRequestModel userLoginData) async {
    try {
      final response = await dio.post(
        ApiConstants.loginMobileAPI,
        data: userLoginData.toJson(),
      );
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
    }
  }

  //! Forgotten pass
  Future<Map<String, dynamic>> forgottenPass(
    ForgotPasswordRequestModel forgotData,
  ) async {
    log("ForgotPassword: ${forgotData.toJson()}");
    try {
      final response = await dio.post(
        ApiConstants.forgetAPI,
        data: forgotData.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': e.error, 'message': e.message};
    }
  }
}

final authrepositoryProvider = Provider<ApiServices>((ref) {
  return ApiServices(ref.read(dioProvider));
});
