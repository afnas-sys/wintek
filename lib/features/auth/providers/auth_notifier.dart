import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/domain/model/forgot_password_model.dart';
import 'package:wintek/features/auth/domain/model/login_model.dart';
import 'package:wintek/features/auth/domain/model/secure_storage_model.dart';
import 'package:wintek/features/auth/domain/model/register_model.dart';
import 'package:wintek/features/auth/domain/model/verify_otp_model.dart';
import 'package:wintek/features/auth/presentaion/widgets/custom_snackbar.dart';
import 'package:wintek/features/auth/services/auth_services.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';

/// Auth State class
class AuthState {
  final bool isLoading;
  final String? message;

  AuthState({this.isLoading = false, this.message});

  AuthState copyWith({bool? isLoading, String? message}) {
    return AuthState(isLoading: isLoading ?? this.isLoading, message: message);
  }
}

final userDraftProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

class AuthNotifier extends StateNotifier<AuthState> {
  final _storage = SecureStorageService();
  final Ref ref;
  final AuthServices apiService;
  SecureStorageService getStorage() => _storage;

  AuthNotifier(this.ref, this.apiService) : super(AuthState());

  //! Send OTP
  /// Sends an OTP to the given mobile number
  ///
  /// This function calls the sendOtp API and returns the response message
  ///
  /// [mobile] The mobile number to which the OTP should be sent
  ///
  /// Returns the response message from the API, or an error message if the API call fails
  Future<String?> sendOtp(String mobile) async {
    state = AuthState(isLoading: true, message: null);
    try {
      final res = await apiService.sendOtp(mobile);
      final msg = res['message'] as String?;
      state = AuthState(isLoading: false, message: msg);
      return msg;
    } catch (e) {
      final errorMessage = (e is Map && e['message'] != null)
          ? e['message'].toString()
          : e.toString();
      state = AuthState(isLoading: false, message: errorMessage);
      return errorMessage;
    }
  }

  //! Register
  /// Registers a new user with the given [signupData]
  ///
  /// This function first saves the [signupData] as a draft in the secure storage.
  /// If the draft is not found, it returns an error message.
  ///
  /// Then, it calls the signup API with the given [signupData].
  /// If the signup is successful, it sends an OTP to the given mobile number
  /// and returns the response message from the API.
  ///
  /// If the signup fails, it returns the error message from the API.
  ///
  /// If an exception occurs while calling the API, it returns null.
  ///
  Future<String?> registerUser(RegisterRequestModel signupData) async {
    ref.read(userDraftProvider.notifier).state = signupData.toJson();
    if (ref.read(userDraftProvider.notifier).state == null) {
      state = AuthState(message: "No registration draft found");
      return "No registration draft found";
    }
    try {
      final res = await apiService.signup(signupData);
      final msg = res['message'];
      if (msg == 'signup') {
        await ref
            .read(authNotifierProvider.notifier)
            .sendOtp(signupData.mobile);
        state = AuthState(message: res['message']);
        return msg;
      } else if (res['status'] == 'failure') {
        state = AuthState(message: res['message']);
        return msg;
      }

      return msg;
    } catch (e) {
      Exception(e.toString());
      return null;
    }
  }

  //! Verify OTP
  /// Verify OTP
  ///
  /// This function takes an OTP and verifies it with the API.
  /// If the OTP is verified successfully, it saves the credentials
  /// in the secure storage and returns true.
  ///
  /// If the OTP verification fails, it returns false.
  ///
  /// If an exception occurs while calling the API, it logs the
  /// error and returns false.
  ///
  Future<bool> verifyOtp({required String otp}) async {
    final draft = ref.read(userDraftProvider);
    if (draft == null) {
      state = AuthState(message: "No registration draft found");
      return false;
    }

    state = AuthState(isLoading: true);
    try {
      final verifyResponce = await apiService.verifyOtp(
        VerifyOtpRequestModel(mobile: draft['mobile'], otp: otp),
      );

      state = AuthState(message: verifyResponce.message);

      if (verifyResponce.status == "success") {
        await _storage.saveCredentials(
          SecureStorageModel(
            token: verifyResponce.tokenData.token,
            cookie: verifyResponce.cookie,
            expiry: verifyResponce.tokenData.expiresIn,
            userId: verifyResponce.data.id,
          ),
        );
        return true;
      }
      return false;
    } catch (e) {
      final errorMessage = (e is Map && e['message'] != null)
          ? e['message'].toString()
          : e.toString();
      state = AuthState(message: errorMessage);
      return false;
    }
  }

  //! login
  /// Logs in a user with the given [userLoginData]
  ///
  /// This function first sets the loading state to true and the
  /// message to null.
  ///
  /// Then, it calls the login API with the given [userLoginData].
  /// If the login is successful and the user is verified, it saves the
  /// credentials in the secure storage.
  /// If the login is successful but the user is not verified, it sends
  /// an OTP to the given mobile number.
  /// If the login fails, it shows a custom snackbar with the error
  /// message and returns null.
  ///
  /// If an exception occurs while calling the API, it logs the error
  Future<LoginResponseModel?> login(
    LoginRequestModel userLoginData,
    BuildContext context,
  ) async {
    state = AuthState(isLoading: true, message: null);
    try {
      final res = await apiService.login(userLoginData);

      state = AuthState(isLoading: false, message: res.message);

      if (res.data.verified && res.status == 'success') {
        await _storage.saveCredentials(
          SecureStorageModel(
            token: res.tokenData.token,
            cookie: res.cookie,
            expiry: res.tokenData.expiresIn,
            userId: res.data.id,
          ),
        );
      } else {
        sendOtp(userLoginData.mobile);
      }

      return res;
    } catch (e) {
      final errorMessage = (e is Map && e['message'] != null)
          ? e['message'].toString()
          : e.toString();
      CustomSnackbar.show(context, message: errorMessage);
      log('error in catch is ${e.toString()}');
      return null;
    }
  }

  //! forgotten password
  /// Forgot password
  ///
  /// This function takes a ForgotPasswordRequestModel and verifies it with the API.
  /// If the OTP is verified successfully, it saves the credentials
  /// in the secure storage and returns true.
  ///
  /// If the OTP verification fails, it returns false.
  ///
  /// If an exception occurs while calling the API, it logs the
  /// error and returns false.
  Future<bool> forgottenPassword(ForgotPasswordRequestModel forgotData) async {
    state = AuthState(isLoading: true);
    try {
      final res = await apiService.forgottenPass(forgotData);

      if (res['status'] == 'success') {
        state = AuthState(
          isLoading: false,
          message: 'Password Changed Success',
        );
        return true;
      }

      state = AuthState(isLoading: false, message: res['message']);
      return false;
    } catch (e) {
      state = AuthState(isLoading: false, message: e.toString());
      return false;
    }
  }

  //! Logout
  /// Logout
  ///
  /// This function clears the credentials from the secure storage
  /// and sets the user draft state to null.
  ///
  /// It is used to logout the user from the app.
  Future<void> logout(WidgetRef ref) async {
    await ref.read(authNotifierProvider.notifier)._storage.clearCredentials();
    ref.read(userDraftProvider.notifier).state = null;
  }
}

/// Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(ref, ref.read(authrepositoryProvider));
});
