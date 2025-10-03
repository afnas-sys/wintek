import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wintek/features/auth/domain/constants/secure_storage_constants.dart';
import 'package:wintek/features/auth/domain/model/google_auth_model.dart';
import 'package:wintek/features/auth/domain/model/secure_storage_model.dart';
import 'package:wintek/features/auth/domain/model/user_data.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  final tokenKey = SecureStorageConstants.tokenKey;
  final cookieKey = SecureStorageConstants.cookieKey;
  final expiryKey = SecureStorageConstants.expiryKey;
  final userIdKey = SecureStorageConstants.userId;
  final userKey = SecureStorageConstants.user;

  Future<void> saveCredentials(SecureStorageModel data) async {
    await _storage.write(key: tokenKey, value: data.token);
    await _storage.write(key: cookieKey, value: data.cookie);
    await _storage.write(key: expiryKey, value: data.expiry);
    await _storage.write(key: userIdKey, value: data.userId);

    log(
      ' vasil 🔑 Token saved: ${data.token} , 🍪 Cookie saved: ${data.cookie} ⏳ Expiry saved: ${data.expiry}  🤦‍♂️userId: ${data.userId}',
    );
  }

  Future<SecureStorageModel> readCredentials() async {
    final token = await _storage.read(key: tokenKey);
    final cookie = await _storage.read(key: cookieKey);
    final expiry = await _storage.read(key: expiryKey);
    final userId = await _storage.read(key: userIdKey);
    return SecureStorageModel(
      token: token,
      cookie: cookie,
      expiry: expiry,
      userId: userId,
    );
  }

  Future<void> saveUserData(UserProfileData user) async {
    await _storage.write(key: userKey, value: jsonEncode(user.toJson()));
  }

  Future<UserProfileData?> readUserData() async {
    final userData = await _storage.read(key: userKey);
    if (userData != null) {
      return UserProfileData.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: tokenKey);
    await _storage.delete(key: cookieKey);
    await _storage.delete(key: expiryKey);
    await _storage.delete(key: userIdKey);
    await _storage.delete(key: userKey);
    log('Storage cleared');
  }
}
