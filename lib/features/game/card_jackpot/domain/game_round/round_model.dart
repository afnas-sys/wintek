class BetModel {
  final String id;
  final String? cardName;
  final DateTime? betTime;
  final num? amount;
  final String status; // "pending", "success", "failed"

  BetModel({
    required this.id,
    this.cardName,
    this.betTime,
    this.amount,
    this.status = "pending",
  });

  BetModel copyWith({
    String? id,
    String? cardName,
    DateTime? betTime,
    num? amount,
    String? status,
  }) {
    return BetModel(
      id: id ?? this.id,
      cardName: cardName ?? this.cardName,
      betTime: betTime ?? this.betTime,
      amount: amount ?? this.amount,
      status: status ?? this.status,
    );
  }
}
