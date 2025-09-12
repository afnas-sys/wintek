import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/domain/model/google_auth_model.dart';
import 'package:wintek/features/auth/domain/model/secure_storage_model.dart';
import 'package:wintek/features/auth/providers/dio_provider.dart';
import 'package:wintek/features/auth/providers/auth_notifier.dart';
import 'package:wintek/features/auth/services/google_auth_services.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';

class GoogleAuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  GoogleAuthNotifier(this.ref) : super(AuthState());
  void setMessage(String msg) {
    state = AuthState(message: msg);
  }

  Future<bool> googleSignIn() async {
    final apiServices = GoogleAuthService(ref.read(dioProvider));
    final storage = SecureStorageService();
    state = AuthState(isLoading: true);

    final user = await apiServices.signInWithGoogle();

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
        );
        await storage.saveCredentials(tokenData);
        final data = await storage.readCredentials();
        log(
          'cookie: ${data.cookie}\nexpiry: ${data.expiry}\ntoken: ${data.token}\n',
        );
        // state = AuthState(isLoading: false);

        return true;
      } else {
        await apiServices.signOut();
        state = AuthState(
          message: 'Login Failed. Please try again.',
          isLoading: false,
        );
        log("Failed SEnt to backend");

        return false;
      }
    }
    state = AuthState(message: 'Google Sign-In Cancelled', isLoading: false);

    log("Google login Failed");

    return false;
  }
}

final googleAuthProvider = StateNotifierProvider(
  (ref) => GoogleAuthNotifier(ref),
);
