import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wintek/features/auth/domain/constants/auth_api_constants.dart';
import 'package:wintek/features/auth/domain/model/google_auth_model.dart';
import 'package:wintek/features/auth/domain/model/secure_storage_model.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/auth/providers/auth_notifier.dart';
import 'package:wintek/features/auth/services/google_auth_services.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/profile/provider/profile_notifier.dart';

class GoogleAuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  GoogleAuthNotifier(this.ref) : super(AuthState());
  void setMessage(String msg) {
    state = AuthState(message: msg);
  }

  /// Sign in with Google
  ///
  /// This function is used to sign in with Google, and then send the user details to the backend
  ///
  /// Returns a Future that resolves to a Map containing a boolean value indicating whether the sign in was successful,
  /// and a string value containing the message returned by the backend
  Future<Map<bool, String>> googleSignIn() async {
    final apiServices = GoogleAuthService(ref.read(dioProvider));
    final storage = SecureStorageService();
    final prefs = await SharedPreferences.getInstance();
    final user = await apiServices.signInWithGoogle();
    state = AuthState(isLoading: false);

    if (user != null) {
      final GoogleAuthResponse? res = await apiServices
          .sendUserDetailsToBackend(user, ref);

      if (res != null && res.status == 'success') {
        state = AuthState(message: res.message, isLoading: false);

        log("✅ User details sent successfully");
        log("Response: ${res.tokenData.toJson()}");
        final tokenData = SecureStorageModel(
          token: res.tokenData.token,
          cookie: res.cookie,
          expiry: res.tokenData.expiresIn,
          userId: res.data.id,
        );
        await storage.saveCredentials(tokenData);
        final data = await storage.readCredentials();
        log(
          'cookie: ${data.cookie}\nexpiry: ${data.expiry}\ntoken: ${data.token}\n',
        );
        ref.invalidate(profileProvider);
        prefs.setBool(AuthApiConstants.isGoogleLogin, true);
        state = AuthState(isLoading: false);

        return {true: res.message};
      } else {
        await apiServices.signOut();
        state = AuthState(isLoading: false);

        log("Failed SEnt to backend");
        return {false: res?.message ?? "Sign in Failed"};
      }
    }
    state = AuthState(isLoading: false);

    log("Google login Failed Not Selected");

    return {false: "Sign in Failed"};
  }
}

final googleAuthProvider = StateNotifierProvider(
  (ref) => GoogleAuthNotifier(ref),
);
