class WalletResponse {
  final bool success;
  final String message;
  final WalletData data;

  WalletResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: WalletData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class WalletData {
  final num balance;

  WalletData({required this.balance});

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(balance: json['balance'] as num);
  }

  Map<String, dynamic> toJson() {
    return {'balance': balance};
  }
}
