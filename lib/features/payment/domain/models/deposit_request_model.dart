class DepositRequestModel {
  final String userId;
  final String transferType;
  final double amount;
  final String type;
  final String? note; // optional
  final String status; // success or failure
  final String taxId;
  final String refId;

  DepositRequestModel({
    required this.userId,
    required this.transferType,
    required this.amount,
    required this.type,
    this.note,
    required this.status,
    required this.taxId,
    required this.refId,
  });

  factory DepositRequestModel.fromJson(Map<String, dynamic> json) {
    return DepositRequestModel(
      userId: json['user_id'] ?? '',
      transferType: json['transfer_type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      type: json['type'] ?? '',
      note: json['note'],
      status: json['status'] ?? '',
      taxId: json['tax_id'] ?? '',
      refId: json['ref_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'transfer_type': transferType,
      'amount': amount,
      'type': type,
      if (note != null) 'note': note,
      'status': status,
      'tax_id': taxId,
      'ref_id': refId,
    };
  }
}
