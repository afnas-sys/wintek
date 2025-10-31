class UserModel {
  final String status;
  final UserData data;

  UserModel({required this.status, required this.data});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data.toJson()};
  }
}

class UserData {
  final String id;
  final String userName;
  final String password;
  final String mobile;
  final double wallet;
  final bool verified;
  final bool otpVerified;
  final bool status;
  final bool isShow;
  final String picture;
  final String branchName;
  final String bankName;
  final String accountHolderName;
  final String accountNo;
  final String ifscCode;
  final String referralCode;
  final String upiId;
  final String upiNumber;
  final bool betting;
  final bool transfer;
  final String fcm;
  final bool personalNotification;
  final bool mainNotification;
  final bool starlineNotification;
  final bool galidisawarNotification;
  final DateTime? transactionBlockedUntil;
  final bool transactionPermanentlyBlocked;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool authentication;
  final DateTime? lastLogin;

  UserData({
    required this.id,
    required this.userName,
    required this.password,
    required this.mobile,
    required this.wallet,
    required this.verified,
    required this.otpVerified,
    required this.status,
    required this.isShow,
    required this.picture,
    required this.branchName,
    required this.bankName,
    required this.accountHolderName,
    required this.accountNo,
    required this.ifscCode,
    required this.referralCode,
    required this.upiId,
    required this.upiNumber,
    required this.betting,
    required this.transfer,
    required this.fcm,
    required this.personalNotification,
    required this.mainNotification,
    required this.starlineNotification,
    required this.galidisawarNotification,
    this.transactionBlockedUntil,
    required this.transactionPermanentlyBlocked,
    required this.createdAt,
    required this.updatedAt,
    required this.authentication,
    required this.lastLogin,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'] ?? '',
      userName: json['user_name'] ?? '',
      password: json['password'] ?? '',
      mobile: json['mobile'] ?? '',
      wallet: (json['wallet'] ?? 0).toDouble(),
      verified: json['verified'] ?? false,
      otpVerified: json['otp_verified'] ?? false,
      status: json['status'] ?? false,
      isShow: json['is_show'] ?? false,
      picture: json['picture'] ?? '',
      branchName: json['branch_name'] ?? '',
      bankName: json['bank_name'] ?? '',
      accountHolderName: json['account_holder_name'] ?? '',
      accountNo: json['account_no'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      referralCode: json['referral_code'] ?? '',
      upiId: json['upi_id'] ?? '',
      upiNumber: json['upi_number'] ?? '',
      betting: json['betting'] ?? false,
      transfer: json['transfer'] ?? false,
      fcm: json['fcm'] ?? '',
      personalNotification: json['personal_notification'] ?? false,
      mainNotification: json['main_notification'] ?? false,
      starlineNotification: json['starline_notification'] ?? false,
      galidisawarNotification: json['galidisawar_notification'] ?? false,
      transactionBlockedUntil: json['transaction_blocked_until'] != null
          ? DateTime.parse(json['transaction_blocked_until'])
          : null,
      transactionPermanentlyBlocked:
          json['transaction_permanently_blocked'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      authentication: json['authentication'] ?? false,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_name': userName,
      'password': password,
      'mobile': mobile,
      'wallet': wallet,
      'verified': verified,
      'otp_verified': otpVerified,
      'status': status,
      'is_show': isShow,
      'picture': picture,
      'branch_name': branchName,
      'bank_name': bankName,
      'account_holder_name': accountHolderName,
      'account_no': accountNo,
      'ifsc_code': ifscCode,
      'referral_code': referralCode,
      'upi_id': upiId,
      'upi_number': upiNumber,
      'betting': betting,
      'transfer': transfer,
      'fcm': fcm,
      'personal_notification': personalNotification,
      'main_notification': mainNotification,
      'starline_notification': starlineNotification,
      'galidisawar_notification': galidisawarNotification,
      'transaction_blocked_until': transactionBlockedUntil?.toIso8601String(),
      'transaction_permanently_blocked': transactionPermanentlyBlocked,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'authentication': authentication,
      'last_login': lastLogin?.toIso8601String(),
    };
  }
}
