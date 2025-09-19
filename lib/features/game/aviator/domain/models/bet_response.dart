class BetResponse {
  final String id;
  final String roundId;
  final String userId;
  final double stake;
  final String currency;
  final double autoCashout;
  final int betIndex;
  final DateTime placedAt;
  final DateTime? cashoutAt;
  final DateTime? cashedOutAt;
  final double? payout;
  final String status;

  BetResponse({
    required this.id,
    required this.roundId,
    required this.userId,
    required this.stake,
    required this.currency,
    required this.autoCashout,
    required this.betIndex,
    required this.placedAt,
    this.cashoutAt,
    this.cashedOutAt,
    this.payout,
    required this.status,
  });

  factory BetResponse.fromJson(Map<String, dynamic> json) {
    return BetResponse(
      id: json['_id'],
      roundId: json['roundId'],
      userId: json['userId'],
      stake: (json['stake'] as num).toDouble(),
      currency: json['currency'],
      autoCashout: (json['autoCashout'] as num).toDouble(),
      betIndex: json['betIndex'],
      placedAt: DateTime.parse(json['placedAt']),
      cashoutAt: json['cashoutAt'] != null
          ? DateTime.parse(json['cashoutAt'])
          : null,
      cashedOutAt: json['cashedOutAt'] != null
          ? DateTime.parse(json['cashedOutAt'])
          : null,
      payout: json['payout'] != null
          ? (json['payout'] as num).toDouble()
          : null,
      status: json['status'],
    );
  }
}
