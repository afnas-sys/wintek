import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wintek/features/auth/domain/constants/api_constants.dart';
import 'package:wintek/features/auth/domain/model/google_auth_model.dart';
import 'package:wintek/features/auth/providers/google_auth_notifier.dart';

class GoogleAuthService {
  final Dio dio;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleAuthService(this.dio);

  /// 🔹 Google Sign-In + Firebase
  Future<GoogleAuthRequest?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;

      if (user != null) {
        final userData = GoogleAuthRequest(
          googleId: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          picture: user.photoURL,
          fcm: "-",
        );
        return userData;
      } else {
        log('NO User Found');
      }
    } catch (e, st) {
      Exception(e);
      log("❌ Error during Google sign-in: $e", stackTrace: st);
    }
    return null;
  }

  ///
  ///
  ///
  ///
  ///
  /// 🔹 Send user details to backend
  ///
  ///
  ///
  ///
  Future<GoogleAuthResponse?> sendUserDetailsToBackend(
    GoogleAuthRequest request,
    Ref ref,
  ) async {
    try {
      final response = await dio.post(
        ApiConstants.googleLoginAPI,
        data: request.toJson(),
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GoogleAuthResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        ref.read(googleAuthProvider.notifier).setMessage('Connection timeout');
      } else {
        ref
            .read(googleAuthProvider.notifier)
            .setMessage('Login Not Completed Please Try Again');
      }
    } catch (e) {
      ref.read(googleAuthProvider.notifier).setMessage('Signup Error');
    }
    return null;
  }

  //
  //
  //
  /// 🔹 Sign out
  //
  //
  Future<String> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return 'Logout Success';
    } catch (e) {
      return 'Logout Failed';
    }
  }
}
