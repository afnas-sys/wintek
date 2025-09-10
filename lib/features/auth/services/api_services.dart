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
    log('user data is  ${signupData.name}     ${signupData.mobile}');
    log(signupData.toJson().toString());
    try {
      final response = await dio.post(
        ApiConstants.signupAPI,
        data: signupData.toJson(),
      );
      log('responce in api sevices is ${response.data}');
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
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
    try {
      final response = await dio.post(
        ApiConstants.forgetAPI,
        data: forgotData.toJson(),
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
