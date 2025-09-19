class SecureStorageConstants {
  // Constant Keys
  static const String _tokenKey = 'auth_token';
  static const String _cookieKey = 'auth_cookie';
  static const String _expiryKey = 'auth_expiry';
  static const String _userId = 'id';

  // Getters
  static String get tokenKey => _tokenKey;
  static String get cookieKey => _cookieKey;
  static String get expiryKey => _expiryKey;
  static String get userId => _userId;
}
