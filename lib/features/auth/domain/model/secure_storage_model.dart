class SecureStorageModel {
  final String? token;
  final String? cookie;
  final String? expiry;

  SecureStorageModel({
    required this.token,
    required this.cookie,
    required this.expiry,
  });

  factory SecureStorageModel.fromJson(Map<String, dynamic> map) {
    return SecureStorageModel(
      token: map['tokenData']?['token'] ?? '',
      expiry: map['tokenData']?['expiresIn'] ?? '',
      cookie: map['cookie'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'expiry': expiry, 'cookie': cookie};
  }
}
