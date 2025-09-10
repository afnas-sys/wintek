class ForgotPasswordRequestModel {
  final String mobile;
  final String otp;
  final String password;

  ForgotPasswordRequestModel({
    required this.mobile,
    required this.otp,
    required this.password,
  });

  factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordRequestModel(
      mobile: json['mobile'] ?? '',
      otp: json['otp'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'mobile': mobile, 'otp': otp, 'password': password};
  }
}
