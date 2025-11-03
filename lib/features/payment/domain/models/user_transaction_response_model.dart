class UserTransactionResponseModel {
  final String status;
  final int total;
  final List<TransactionData> data;

  UserTransactionResponseModel({
    required this.status,
    required this.total,
    required this.data,
  });

  factory UserTransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return UserTransactionResponseModel(
      status: json['status'] ?? '',
      total: json['total'] ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => TransactionData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'total': total,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class TransactionData {
  final String id;
  final User? user;
  final double amount;
  final String type;
  final String status;
  final String taxId;
  final String refId;
  final double prevBalance;
  final double currentBalance;
  final String createdAt;
  final String updatedAt;
  final String? transferType;
  final String? agentId;

  TransactionData({
    required this.id,
    required this.user,
    required this.amount,
    required this.type,
    required this.status,
    required this.taxId,
    required this.refId,
    required this.prevBalance,
    required this.currentBalance,
    required this.createdAt,
    required this.updatedAt,
    required this.transferType,
    required this.agentId,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['_id'] ?? '',
      user: json['user_id'] != null ? User.fromJson(json['user_id']) : null,
      amount: (json['amount'] ?? 0).toDouble(),
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      taxId: json['tax_id'] ?? '',
      refId: json['ref_id'] ?? '',
      prevBalance: (json['prev_balance'] ?? 0).toDouble(),
      currentBalance: (json['current_balance'] ?? 0).toDouble(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      transferType: json['transfer_type'],
      agentId: json['agent_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user_id': user?.toJson(),
    'amount': amount,
    'type': type,
    'status': status,
    'tax_id': taxId,
    'ref_id': refId,
    'prev_balance': prevBalance,
    'current_balance': currentBalance,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'transfer_type': transferType,
    'agent_id': agentId,
  };
}

class User {
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
  final String transactionBlockedUntil;
  final bool transactionPermanentlyBlocked;
  final String createdAt;
  final String updatedAt;
  final bool authentication;
  final String lastLogin;
  final String dateOfBirth;
  final String gender;

  User({
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
    required this.transactionBlockedUntil,
    required this.transactionPermanentlyBlocked,
    required this.createdAt,
    required this.updatedAt,
    required this.authentication,
    required this.lastLogin,
    required this.dateOfBirth,
    required this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
      transactionBlockedUntil: json['transaction_blocked_until'] ?? '',
      transactionPermanentlyBlocked:
          json['transaction_permanently_blocked'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      authentication: json['authentication'] ?? false,
      lastLogin: json['last_login'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
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
    'transaction_blocked_until': transactionBlockedUntil,
    'transaction_permanently_blocked': transactionPermanentlyBlocked,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'authentication': authentication,
    'last_login': lastLogin,
    'date_of_birth': dateOfBirth,
    'gender': gender,
  };
}
