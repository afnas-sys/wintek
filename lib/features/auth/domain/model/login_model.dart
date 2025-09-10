class LoginRequestModel {
  final String mobile;
  final String password;
  final String? fcm;

  LoginRequestModel({required this.mobile, required this.password, this.fcm});

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'password': password,
      if (fcm != null) 'fcm': fcm,
    };
  }

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      mobile: json['mobile'] ?? '',
      password: json['password'] ?? '',
      fcm: json['fcm'],
    );
  }
}

class LoginResponseModel {
  final String status;
  final String message;
  final TokenData tokenData;
  final String cookie;
  final UserData data;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.tokenData,
    required this.cookie,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      tokenData: TokenData.fromJson(json['tokenData'] ?? {}),
      cookie: json['cookie'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'tokenData': tokenData.toJson(),
      'cookie': cookie,
      'data': data.toJson(),
    };
  }
}

class TokenData {
  final String expiresIn;
  final String token;

  TokenData({required this.expiresIn, required this.token});

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      expiresIn: json['expiresIn'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'expiresIn': expiresIn, 'token': token};
  }
}

class UserData {
  final String id;
  final String mobile;
  final bool verified;

  UserData({required this.id, required this.mobile, required this.verified});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      mobile: json['mobile'] ?? '',
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'mobile': mobile, 'verified': verified};
  }
}
