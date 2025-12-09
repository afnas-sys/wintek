class BalanceUpdateEvent {
  final double balance;
  final String userId;

  BalanceUpdateEvent({required this.balance, required this.userId});

  factory BalanceUpdateEvent.fromJson(Map<String, dynamic> json) {
    return BalanceUpdateEvent(
      balance: (json['balance'] as num).toDouble(),
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'balance': balance, 'userId': userId};
  }
}
