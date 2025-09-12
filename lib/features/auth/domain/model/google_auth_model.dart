class GoogleAuthRequest {
  final String googleId;
  final String email;
  final String name;
  final String? picture;
  final String? referralCode;
  final String fcm;

  GoogleAuthRequest({
    required this.googleId,
    required this.email,
    required this.name,
    this.picture,
    this.referralCode,
    this.fcm = "-",
  });

  factory GoogleAuthRequest.fromJson(Map<String, dynamic> json) {
    return GoogleAuthRequest(
      googleId: json['googleId'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      picture: json['picture'],
      referralCode: json['referral_code'],
      fcm: json['fcm'] ?? "-",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "googleId": googleId,
      "email": email,
      "name": name,
      if (picture != null) "picture": picture,
      if (referralCode != null) "referral_code": referralCode,
      "fcm": fcm,
    };
  }
}

// Google Auth responce Model

class GoogleAuthResponse {
  final String status;
  final String message;
  final TokenData tokenData;
  final String cookie;
  final UserData data;

  GoogleAuthResponse({
    required this.status,
    required this.message,
    required this.tokenData,
    required this.cookie,
    required this.data,
  });

  factory GoogleAuthResponse.fromJson(Map<String, dynamic> json) {
    return GoogleAuthResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      tokenData: TokenData.fromJson(json['tokenData'] ?? {}),
      cookie: json['cookie'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "tokenData": tokenData.toJson(),
      "cookie": cookie,
      "data": data.toJson(),
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
    return {"expiresIn": expiresIn, "token": token};
  }
}

class UserData {
  final String id;
  final String email;
  final String name;
  final bool verified;
  final int wallet;
  final String googleId;

  UserData({
    required this.id,
    required this.email,
    required this.name,
    required this.verified,
    required this.wallet,
    required this.googleId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      verified: json['verified'] ?? false,
      wallet: json['wallet'] ?? 0,
      googleId: json['googleId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "verified": verified,
      "wallet": wallet,
      "googleId": googleId,
    };
  }
}
