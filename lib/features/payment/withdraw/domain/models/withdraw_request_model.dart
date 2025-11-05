class WithdrawRequestModel {
  final String userId;
  final String transferType;
  final num amount;
  final String type;
  final String withdrawType;
  final String? note;

  WithdrawRequestModel({
    required this.userId,
    required this.transferType,
    required this.amount,
    required this.type,
    required this.withdrawType,
    this.note,
  });

  factory WithdrawRequestModel.fromJson(Map<String, dynamic> json) {
    return WithdrawRequestModel(
      userId: json['user_id'] ?? '',
      transferType: json['transfer_type'] ?? '',
      amount: json['amount'] ?? 0,
      type: json['type'] ?? '',
      withdrawType: json['withdraw_type'] ?? '',
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'transfer_type': transferType,
      'amount': amount,
      'type': type,
      'withdraw_type': withdrawType,
      if (note != null && note!.isNotEmpty) 'note': note,
    };
  }
}
