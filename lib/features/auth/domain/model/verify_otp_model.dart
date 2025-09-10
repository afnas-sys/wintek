class VerifyOtpRequestModel {
  final String mobile;
  final String otp;

  VerifyOtpRequestModel({required this.mobile, required this.otp});

  factory VerifyOtpRequestModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpRequestModel(
      mobile: json['mobile'] ?? '',
      otp: json['otp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'mobile': mobile, 'otp': otp};
  }
}

class VerifyOtpResponseModel {
  final String status;
  final String message;
  final TokenData tokenData;
  final String cookie;
  final UserData data;

  VerifyOtpResponseModel({
    required this.status,
    required this.message,
    required this.tokenData,
    required this.cookie,
    required this.data,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
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

  UserData({required this.id, required this.mobile});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(id: json['id'] ?? '', mobile: json['mobile'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'mobile': mobile};
  }
}
