class SecureStorageModel {
  final String? token;
  final String? cookie;
  final String? expiry;
  final String? userId;

  SecureStorageModel({
    required this.token,
    required this.cookie,
    required this.expiry,
    required this.userId,
  });

  factory SecureStorageModel.fromJson(Map<String, dynamic> map) {
    return SecureStorageModel(
      token: map['tokenData']?['token'] ?? '',
      expiry: map['tokenData']?['expiresIn'] ?? '',
      cookie: map['cookie'] ?? '',
      userId: map['data']?['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'expiry': expiry, 'cookie': cookie, 'id': userId};
  }
}
