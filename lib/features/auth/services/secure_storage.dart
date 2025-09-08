import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  // Keys
  static const _tokenKey = 'auth_token';
  static const _cookieKey = 'auth_cookie';
  static const _expiryKey = 'auth_expiry';

  Future<void> saveCredentials({
    required String token,
    required String cookie,
    required String expiry,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _cookieKey, value: cookie);
    await _storage.write(key: _expiryKey, value: expiry);

    log("🔑 Token saved: $token");
    log("🍪 Cookie saved: $cookie");
    log("⏳ Expiry saved: $expiry");
  }

  Future<Map<String, String?>> readCredentials() async {
    final token = await _storage.read(key: _tokenKey);
    final cookie = await _storage.read(key: _cookieKey);
    final expiry = await _storage.read(key: _expiryKey);
    return {'token': token, 'cookie': cookie, 'expiry': expiry};
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _cookieKey);
    await _storage.delete(key: _expiryKey);
  }
}
