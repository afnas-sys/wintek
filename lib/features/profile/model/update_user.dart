class UpdateProfile {
  final String id;
  final String? fcm;
  final String? userName;
  final String? upiNumber;
  final String? upiId;
  final String? bankName;
  final String? accountHolderName;
  final String? accountNo;
  final String? ifscCode;
  final String? branchName;
  final String? gender;
  final String? dateOfBirth;

  UpdateProfile({
    required this.id,
    this.fcm,
    this.userName,
    this.upiNumber,
    this.upiId,
    this.bankName,
    this.accountHolderName,
    this.accountNo,
    this.ifscCode,
    this.branchName,
    this.gender,
    this.dateOfBirth,
  });

  factory UpdateProfile.fromJson(Map<String, dynamic> json) {
    return UpdateProfile(
      id: json['id'] ?? '',
      fcm: json['fcm'],
      userName: json['user_name'],
      upiNumber: json['upi_number'],
      upiId: json['upi_id'],
      bankName: json['bank_name'],
      accountHolderName: json['account_holder_name'],
      accountNo: json['account_no'],
      ifscCode: json['ifsc_code'],
      branchName: json['branch_name'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (fcm != null) 'fcm': fcm,
      if (userName != null) 'user_name': userName,
      if (upiNumber != null) 'upi_number': upiNumber,
      if (upiId != null) 'upi_id': upiId,
      if (bankName != null) 'bank_name': bankName,
      if (accountHolderName != null) 'account_holder_name': accountHolderName,
      if (accountNo != null) 'account_no': accountNo,
      if (ifscCode != null) 'ifsc_code': ifscCode,
      if (branchName != null) 'branch_name': branchName,
      if (gender != null) 'gender': gender,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
    };
  }
}
