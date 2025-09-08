import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/services/api_services.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';

/// Auth State class
class AuthState {
  final bool isLoading;
  final String? message;
  AuthState({this.isLoading = false, this.message});
}

/// User draft provider (to temporarily store details until OTP is verified)
final userDraftProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

/// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final _storage = SecureStorageService();
  final Ref ref;
  final ApiServices apiService;

  AuthNotifier(this.ref, this.apiService) : super(AuthState());

  /// Register step 1 → Send OTP and save draft
  Future<void> registerWithMobile({
    required String name,
    required String mobile,
    required String password,
    // String? email,
    String? referralCode,
  }) async {
    state = AuthState(isLoading: true);
    try {
      await sendOtp(mobile);

      // Save user draft temporarily
      ref.read(userDraftProvider.notifier).state = {
        'name': name,
        'mobile': mobile,
        'password': password,
        //'email': email,
        'referralCode': referralCode,
      };

      state = AuthState(message: "OTP sent successfully");
    } catch (e) {
      state = AuthState(message: e.toString());
    }
  }

  /// Send OTP only
  Future<void> sendOtp(String mobile) async {
    state = AuthState(isLoading: true);
    try {
      final res = await apiService.sendOtp(mobile);
      state = AuthState(message: res['message']);
    } catch (e) {
      state = AuthState(message: e.toString());
    }
  }

  ///! Step 2 → Verify OTP, then signup
  Future<void> verifyOtpAndSignup({required String otp}) async {
    final draft = ref.read(userDraftProvider);

    if (draft == null) {
      state = AuthState(message: "No registration draft found");
      return;
    }

    state = AuthState(isLoading: true);
    try {
      // First verify OTP
      final verifyRes = await apiService.verifyOtp(
        mobile: draft['mobile'],
        otp: otp,
      );

      // Save credentials
      await _storage.saveCredentials(
        token: verifyRes['tokenData']['token'],
        cookie: verifyRes['cookie'].toString(),
        expiry: verifyRes['tokenData']['expiresIn'].toString(),
      );
      final token = verifyRes['tokenData']['token'];
      final cookie = verifyRes['cookie'];
      final expiry = verifyRes['tokenData']['expiresIn'];
      log('SECURE STORAGE TOKEN: $token');
      log('SECURE STORAGE COOKIE: $cookie');
      log('SECURE STORAGE EXPIRY: $expiry');

      // After OTP success → do signup
      final res = await apiService.signup(
        name: draft['name'],
        mobile: draft['mobile'],
        password: draft['password'],
        referralCode: draft['referralCode'],
      );

      state = AuthState(message: res['message']);
    } catch (e) {
      state = AuthState(message: e.toString());
    }
  }

  //! login
  Future<void> login({required String mobile, required String password}) async {
    state = AuthState(isLoading: true);
    try {
      final res = await apiService.login(mobile: mobile, password: password);

      //SAVE Credentials
      _storage.saveCredentials(
        token: res['tokenData']['token'],
        cookie: res['cookie'],
        expiry: res['tokenData']['expiresIn'],
      );

      state = AuthState(message: res['message']);
    } catch (e) {
      state = AuthState(message: e.toString());
    }
  }

  //! forgotten password
  Future<void> forgottenPassword({
    required String mobile,
    required String password,
    required String otp,
  }) async {
    state = AuthState(isLoading: true);
    try {
      final res = await apiService.forgottenPass(
        mobile: mobile,
        password: password,
        otp: otp,
      );
      state = AuthState(message: res['message']);
    } catch (e) {
      state = AuthState(message: e.toString());
    }
  }
}

/// Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(ref, ref.read(authrepositoryProvider));
});
