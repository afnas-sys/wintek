import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wintek/features/auth/domain/constants/auth_api_constants.dart';
import 'package:wintek/features/auth/domain/model/google_auth_model.dart';
import 'package:wintek/features/auth/providers/google_auth_notifier.dart';

class GoogleAuthService {
  final Dio dio;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleAuthService(this.dio);

  /// Sign in with Google
  ///
  /// This function signs in with Google using the Google Sign In library
  /// and then uses the Firebase Authentication library to sign in the user
  /// with the obtained credential.
  ///
  /// If the sign in is successful, a GoogleAuthRequest object is returned
  /// containing the user's data. If the sign in fails or no user is found,
  /// null is returned.
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

  /// Sends the user's details to the backend server after a successful Google sign-in.
  ///
  /// This function makes a POST request to the server with the user's details.
  /// If the response is successful (200 or 201), a [GoogleAuthResponse] object is returned.
  /// If the response is not successful, an error message is set in the [GoogleAuthNotifier] and null is returned.
  ///
  /// If a [DioException] occurs during the request, an error message is set in the [GoogleAuthNotifier] and null is returned.
  /// If any other exception occurs, an error message is set in the [GoogleAuthNotifier] and null is returned.
  Future<GoogleAuthResponse?> sendUserDetailsToBackend(
    GoogleAuthRequest request,
    Ref ref,
  ) async {
    try {
      final response = await dio.post(
        AuthApiConstants.googleLoginAPI,
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

  /// Signs out the user from Google and Firebase authentication.
  ///
  /// This function first signs out the user from Google sign-in.
  /// Then, it signs out the user from Firebase authentication.
  ///
  /// If both sign-outs are successful, 'Logout Success' is returned.
  /// If either sign-out fails, 'Logout Failed' is returned.
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
