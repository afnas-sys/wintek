import 'package:dio/dio.dart';
import 'package:wintek/core/constants/api_constants/api_constants.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';

class ChangePasswordModel {
  final String oldPassword;
  final String newPassword;
  final String mobileNumber;
  ChangePasswordModel({
    required this.oldPassword,
    required this.newPassword,
    required this.mobileNumber,
  });
  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'password': newPassword,
      'mobile': mobileNumber,
    };
  }
}

class ProfileServices {
  final Dio dio;
  ProfileServices(this.dio);
  //
  /// Changes the user's password given the old password, new password and mobile number.
  ///
  /// This function sends a change password request to the API with the given data.
  /// If the request is successful, it returns a [Map] containing the response from the API.
  /// If the request fails, it returns a [Map] containing the error message from the API.
  /// If an exception occurs while calling the API, it re-throws the exception.
  Future<Map<String, dynamic>> changePassword(ChangePasswordModel data) async {
    final secureData = await SecureStorageService().readCredentials();
    try {
      final res = await dio.post(
        ApiContants.changePasswordUrl,
        data: data.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer ${secureData.token}'},
        ),
      );
      return res.statusCode == 200 || res.statusCode == 201
          ? {
              'status': 'success',
              'message': res.data['message'] ?? 'Password changed successfully',
            }
          : {
              'status': 'failure',
              'message': res.data['message'] ?? 'Failed to change password',
            };
    } catch (e) {
      return {'status': 'error', 'message': 'Error occurred'};
    }
  }

  /// Fetches the user's data from the API.
  ///
  /// This function sends a GET request to the API with the user's token and user id.
  /// If the request is successful, it returns a [Map] containing the user's data.
  /// If the request fails, it returns a [Map] containing the error message from the API.
  /// If an exception occurs while calling the API, it re-throws the exception.
  Future<Map<String, dynamic>> fetchUserData() async {
    final secureData = await SecureStorageService().readCredentials();
    final url = '${ApiContants.fetchUserUrl}${secureData.userId}';
    try {
      final res = await dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer ${secureData.token}'},
        ),
      );
      return res.data;
    } catch (e) {
      return {'status': 'error', 'message': 'Error occurred'};
    }
  }
}
