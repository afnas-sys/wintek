import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wintek/features/auth/domain/constants/secure_storage_constants.dart';
import 'package:wintek/features/auth/domain/model/secure_storage_model.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  final tokenKey = SecureStorageConstants.tokenKey;
  final cookieKey = SecureStorageConstants.cookieKey;
  final expiryKey = SecureStorageConstants.expiryKey;

  Future<void> saveCredentials(SecureStorageModel data) async {
    await _storage.write(key: tokenKey, value: data.token);
    await _storage.write(key: cookieKey, value: data.cookie);
    await _storage.write(key: expiryKey, value: data.expiry);

    log(
      ' vasil 🔑 Token saved: ${data.token} , 🍪 Cookie saved: ${data.cookie} ⏳ Expiry saved: ${data.expiry}  ',
    );
  }

  Future<SecureStorageModel> readCredentials() async {
    final token = await _storage.read(key: tokenKey);
    final cookie = await _storage.read(key: cookieKey);
    final expiry = await _storage.read(key: expiryKey);
    return SecureStorageModel(token: token, cookie: cookie, expiry: expiry);
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: tokenKey);
    await _storage.delete(key: cookieKey);
    await _storage.delete(key: expiryKey);
  }
}
