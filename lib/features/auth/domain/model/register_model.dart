class RegisterRequestModel {
  final String name;
  final String mobile;
  final String password;
  final String? referralCode;
  final String fcm;
  //final String email;

  RegisterRequestModel({
    required this.name,
    required this.mobile,
    required this.password,
    this.referralCode,
    this.fcm = "-",
    //  this.email = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'user_name': name,
      'mobile': mobile,
      'password': password,
      'referral_code': referralCode ?? '',
      'fcm': fcm,
      //  'email': email,
    };
  }

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      name: json['user_name'] ?? '',
      mobile: json['mobile'] ?? '',
      password: json['password'] ?? '',
      referralCode: json['referral_code'],
      fcm: json['fcm'] ?? '-',
      //  email: json['email'] ?? '',
    );
  }
}
