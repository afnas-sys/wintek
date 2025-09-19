import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/domain/constants/auth_api_constants.dart';
import 'package:wintek/features/auth/domain/model/forgot_password_model.dart';
import 'package:wintek/features/auth/domain/model/login_model.dart';
import 'package:wintek/features/auth/domain/model/register_model.dart';
import 'package:wintek/features/auth/domain/model/verify_otp_model.dart';
import 'package:wintek/core/network/dio_provider.dart';

class AuthServices {
  final Dio dio;

  AuthServices(this.dio);

  //!SignUp
  /// Signup user with the given [signupData]
  ///
  /// This function calls the signup API with the given [signupData]
  /// and returns the response message from the API.
  ///
  /// If the signup is successful, it returns the response message from the API.
  /// If the signup fails, it returns the error message from the API.
  ///
  /// If an exception occurs while calling the API, it returns null.
  Future<Map<String, dynamic>> signup(RegisterRequestModel signupData) async {
    log('user data is ${signupData.name} ${signupData.mobile}');
    log(signupData.toJson().toString());

    try {
      final response = await dio.post(
        AuthApiConstants.signupAPI,
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
  /// Sends an OTP to the given mobile number
  ///
  /// This function calls the sendOtp API with the given [mobile]
  /// and returns the response message from the API.
  ///
  /// If the OTP is sent successfully, it returns the response message from the API.
  /// If the OTP sending fails, it returns the error message from the API.
  ///
  Future<Map<String, dynamic>> sendOtp(String mobile) async {
    log('otp is sented to  $mobile');
    try {
      final response = await dio.post(
        AuthApiConstants.sentotpAPI,
        data: {'mobile': mobile},
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
    }
  }

  //! otp verify
  /// Verify OTP
  ///
  /// This function takes an OTP and verifies it with the API.
  /// If the OTP is verified successfully, it returns a VerifyOtpResponseModel
  /// containing the response from the API.
  /// If the OTP verification fails, it returns a VerifyOtpResponseModel
  /// containing the error message from the API.
  ///
  /// If an exception occurs while calling the API, it re-throws the
  /// exception.
  Future<VerifyOtpResponseModel> verifyOtp(
    VerifyOtpRequestModel otpRequestData,
  ) async {
    try {
      final response = await dio.post(
        AuthApiConstants.otpVerifyAPI,
        data: otpRequestData.toJson(),
      );

      return VerifyOtpResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
    }
  }

  //! Log in
  /// Log in a user with the given [userLoginData]
  ///
  /// This function takes a [LoginRequestModel] containing the user's
  /// login data and calls the login API with it.
  /// If the login is successful, it returns a [LoginResponseModel]
  /// containing the response from the API.
  /// If the login fails, it returns a [LoginResponseModel]
  /// containing the error message from the API.
  ///
  /// If an exception occurs while calling the API, it re-throws the
  /// exception.
  Future<LoginResponseModel> login(LoginRequestModel userLoginData) async {
    try {
      final response = await dio.post(
        AuthApiConstants.loginMobileAPI,
        data: userLoginData.toJson(),
      );
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': 'failure', 'message': e.message};
    }
  }

  //! Forgotten pass
  /// Sends a forgotten password request to the API
  ///
  /// This function takes a [ForgotPasswordRequestModel] containing the
  /// user's forgotten password data and calls the forgot password API
  /// with it.
  ///
  /// If the request is successful, it returns a [Map] containing
  /// the response from the API.
  ///
  /// If the request fails, it returns a [Map] containing the error
  /// message from the API.
  ///
  /// If an exception occurs while calling the API, it re-throws the
  /// exception.
  Future<Map<String, dynamic>> forgottenPass(
    ForgotPasswordRequestModel forgotData,
  ) async {
    log("ForgotPassword: ${forgotData.toJson()}");
    try {
      final response = await dio.post(
        AuthApiConstants.forgetAPI,
        data: forgotData.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data ?? {'status': e.error, 'message': e.message};
    }
  }
}

final authrepositoryProvider = Provider<AuthServices>((ref) {
  return AuthServices(ref.read(dioProvider));
});
