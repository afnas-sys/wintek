class CashoutResponse {
  final String id;
  final String roundId;
  final String userId;
  final int stake;
  final String currency;
  final double? autoCashout;
  final int betIndex;
  final String placedAt;
  final double? cashoutAt;
  final String? cashedOutAt;
  final double? payout;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int v;

  CashoutResponse({
    required this.id,
    required this.roundId,
    required this.userId,
    required this.stake,
    required this.currency,
    this.autoCashout,
    required this.betIndex,
    required this.placedAt,
    this.cashoutAt,
    this.cashedOutAt,
    this.payout,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CashoutResponse.fromJson(Map<String, dynamic> json) {
    return CashoutResponse(
      id: json['_id'],
      roundId: json['roundId'],
      userId: json['userId'],
      stake: json['stake'],
      currency: json['currency'],
      autoCashout: json['autoCashout'] != null
          ? (json['autoCashout'] as num).toDouble()
          : null,
      betIndex: json['betIndex'],
      placedAt: json['placedAt'],
      cashoutAt: json['cashoutAt'] != null
          ? (json['cashoutAt'] as num).toDouble()
          : null,
      cashedOutAt: json['cashedOutAt'],
      payout: json['payout'] != null
          ? (json['payout'] as num).toDouble()
          : null,
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "roundId": roundId,
      "userId": userId,
      "stake": stake,
      "currency": currency,
      "autoCashout": autoCashout,
      "betIndex": betIndex,
      "placedAt": placedAt,
      "cashoutAt": cashoutAt,
      "cashedOutAt": cashedOutAt,
      "payout": payout,
      "status": status,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}
