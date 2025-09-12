import 'dart:developer';
// <<<<<<< google_auth
// =======

// >>>>>>> main
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

// <<<<<<< google_auth
  /// Send OTP only
// =======
  ! Send OTP
// >>>>>>> main
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

// <<<<<<< google_auth
//   /*

//   */
//   ///! Step 2 → Verify OTP, then signup
//   Future<bool> verifyOtpAndSignup({required String otp}) async {
// =======
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
// >>>>>>> main
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
// <<<<<<< google_auth
//         log('otp verificatio for registration is success');
//         log('user data is in verify otp $draft');
//         final signupResponce = await apiService.signup(
//           RegisterRequestModel.fromJson(draft),
//         );
//         log('signup responce is outside checking $signupResponce');
//         if (signupResponce['status'] == "failure") {
//           log('sign up  is success');
//           log('sign up responce is ${signupResponce['message']}');

//           await _storage.saveCredentials(
//             SecureStorageModel(
//               token: verifyResponce.tokenData.token,
//               cookie: verifyResponce.cookie,
//               expiry: verifyResponce.tokenData.expiresIn,
//             ),
//           );
//           return true;
//         } else {
//           state = AuthState(message: 'User Signup error');
//         }
// =======
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
// >>>>>>> main
      }
      return false;
    } catch (e) {
      state = AuthState(message: e.toString());
      return false;
    }
  }

// <<<<<<< google_auth
  /*

  */
  //! login
//   Future<void> login(LoginRequestModel userLoginData) async {
// =======
  //! login
  Future<bool> login(LoginRequestModel userLoginData) async {
// >>>>>>> main
    state = AuthState(isLoading: true);
    try {
      final res = await apiService.login(userLoginData);

      if (res.status == 'success') {
// <<<<<<< google_auth
        //SAVE Credentials

// =======
// >>>>>>> main
        _storage.saveCredentials(
          SecureStorageModel(
            token: res.tokenData.token,
            cookie: res.cookie,
            expiry: res.tokenData.expiresIn,
          ),
        );
// <<<<<<< google_auth
//       }

//       state = AuthState(message: res.message);
//     } catch (e) {
//       state = AuthState(message: e.toString());
//     }
//   }

  /*

  */
// =======
        return true;
      }

      state = AuthState(message: res.message);
      return false;
    } catch (e) {
      state = AuthState(message: e.toString());
      return false;
    }
  }

// >>>>>>> main
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
// <<<<<<< google_auth
// }

// /*

// */
// =======

  //! Logout
  Future<void> logout(WidgetRef ref) async {
    await ref.read(authNotifierProvider.notifier)._storage.clearCredentials();
    ref.read(userDraftProvider.notifier).state = null;
  }
}

// >>>>>>> main
/// Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(ref, ref.read(authrepositoryProvider));
});
