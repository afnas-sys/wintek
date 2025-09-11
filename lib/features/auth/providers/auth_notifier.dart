import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/domain/model/forgot_password_model.dart';
import 'package:wintek/features/auth/domain/model/login_model.dart';
import 'package:wintek/features/auth/domain/model/secure_storage_model.dart';
import 'package:wintek/features/auth/domain/model/register_model.dart';
import 'package:wintek/features/auth/domain/model/verify_otp_model.dart';
import 'package:wintek/features/auth/services/api_services.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';

/// Auth State class
class AuthState {
  final bool isLoading;
  final String? message;
  AuthState({this.isLoading = false, this.message});
}

final userDraftProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

class AuthNotifier extends StateNotifier<AuthState> {
  final _storage = SecureStorageService();
  final Ref ref;
  final ApiServices apiService;

  AuthNotifier(this.ref, this.apiService) : super(AuthState());

  //! Send OTP
  Future<bool> sendOtp(String mobile) async {
    state = AuthState(isLoading: true);
    try {
      final res = await apiService.sendOtp(mobile);
      state = AuthState(message: res['message']);
      state = AuthState(isLoading: false);

      return res['status'] == 'success';
    } catch (e) {
      state = AuthState(message: e.toString());
      return false;
    }
  }

  //! Register
  Future<bool> registerUser(RegisterRequestModel signupData) async {
    ref.read(userDraftProvider.notifier).state = signupData.toJson();
    if (ref.read(userDraftProvider.notifier).state == null) {
      state = AuthState(message: "No registration draft found");
      return false;
    }
    try {
      final res = await apiService.signup(signupData);
      log('Responce is ${res['message']}');
      if (res['message'] == 'signup') {
        await ref
            .read(authNotifierProvider.notifier)
            .sendOtp(signupData.mobile);
        state = AuthState(message: res['message']);
        ref.read(userDraftProvider.notifier).state = null;
        return true;
      } else if (res['status'] == 'failure') {
        log(' ALREADY USER EXIST ${res['message']}');
        state = AuthState(message: res['message']);
        log('STATE MESSAGE IS ${state.message}');
        return false;
      }

      return false;
    } catch (e) {
      Exception(e.toString());
      return false;
    }
  }

  //! Verify OTP
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
        // final signupResponce = await apiService.signup(
        //   RegisterRequestModel.fromJson(draft),
        // );

        await _storage.saveCredentials(
          SecureStorageModel(
            token: verifyResponce.tokenData.token,
            cookie: verifyResponce.cookie,
            expiry: verifyResponce.tokenData.expiresIn,
          ),
        );
        return true;
      }
      return false;
    } catch (e) {
      state = AuthState(message: e.toString());
      return false;
    }
  }

  //! login
  Future<bool> login(LoginRequestModel userLoginData) async {
    state = AuthState(isLoading: true);
    try {
      final res = await apiService.login(userLoginData);

      if (res.status == 'success') {
        _storage.saveCredentials(
          SecureStorageModel(
            token: res.tokenData.token,
            cookie: res.cookie,
            expiry: res.tokenData.expiresIn,
          ),
        );
        return true;
      }

      state = AuthState(message: res.message);
      return false;
    } catch (e) {
      state = AuthState(message: e.toString());
      return false;
    }
  }

  //! forgotten password
  Future<bool> forgottenPassword(ForgotPasswordRequestModel forgotData) async {
    state = AuthState(isLoading: true);
    try {
      final res = await apiService.forgottenPass(forgotData);

      if (res['status'] == 'success') {
        state = AuthState(message: 'Password Changed Success');
        return true;
      }

      state = AuthState(message: res['message']);
      return false;
    } catch (e) {
      state = AuthState(message: e.toString());
      return false;
    }
  }

  //! Logout
  Future<void> logout(WidgetRef ref) async {
    await ref.read(authNotifierProvider.notifier)._storage.clearCredentials();
  }
}

/// Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(ref, ref.read(authrepositoryProvider));
});
