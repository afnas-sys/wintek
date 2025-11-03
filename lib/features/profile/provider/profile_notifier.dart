import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/profile/model/update_user.dart';
import 'package:wintek/features/profile/services/profile_services.dart';

final profileProvider = StateProvider<ProfileNotifier>((ref) {
  return ProfileNotifier(ref, ProfileServices(ref.watch(dioProvider)));
});

final currentUserDataProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.watch(profileProvider).fetchUserData();
});

class ProfileNotifier extends StateNotifier {
  final Ref ref;
  ProfileServices apiService;
  ProfileNotifier(this.ref, this.apiService) : super(null);

  /// Calls the change password API with the given [ChangePasswordModel] data.
  /// Returns a [Map] containing the response from the API.
  /// If the request is successful, it returns a [Map] containing
  /// the response from the API.
  /// If the request fails, it returns a [Map] containing the error
  /// message from the API.

  Future<Map<String, dynamic>> changePassword(ChangePasswordModel data) async {
    final res = await apiService.changePassword(data);
    return res;
  }

  /// Fetches the user's data from the API.
  ///
  /// This function sends a GET request to the API with the user's token and user id.
  /// If the request is successful, it returns a [Map] containing the user's data.
  /// If the request fails, it returns a [Map] containing the error message from the API.
  /// If an exception occurs while calling the API, it re-throws the exception.
  Future<Map<String, dynamic>> fetchUserData() async {
    final res = await apiService.fetchUserData();
    return res;
  }

  /// Updates the user's profile with the given [UpdateProfile] data.
  /// Returns a [Map] containing the response from the API.
  /// If the request is successful, it returns a [Map] containing
  /// the response from the API.
  /// If the request fails, it returns a [Map] containing the error
  /// message from the API.
  Future<Map<String, dynamic>> updateProfile(UpdateProfile data) async {
    final res = await apiService.updateProfile(data);
    return res;
  }
}
