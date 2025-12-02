class CrashCashoutResponseModel {
  final String? roundId;
  final String? userId;
  final int? stake;
  final String? currency;
  final int? betIndex;
  final double? autoCashout;
  final String? placedAt;
  final double? cashoutAt;
  final String? cashedOutAt;
  final double? payout;
  final String? status;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

  CrashCashoutResponseModel({
    this.roundId,
    this.userId,
    this.stake,
    this.currency,
    this.autoCashout,
    this.betIndex,
    this.placedAt,
    this.cashoutAt,
    this.cashedOutAt,
    this.payout,
    this.status,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory CrashCashoutResponseModel.fromJson(Map<String, dynamic> json) {
    return CrashCashoutResponseModel(
      roundId: json['roundId']?.toString(),
      userId: json['userId']?.toString(),
      stake: json['stake'] is int ? json['stake'] : null,
      currency: json['currency']?.toString(),
      autoCashout: (json['autoCashout'] as num?)?.toDouble(),
      betIndex: json['betIndex'] is int ? json['betIndex'] : null,
      placedAt: json['placedAt']?.toString(),
      cashoutAt: (json['cashoutAt'] as num?)?.toDouble(),
      cashedOutAt: json['cashedOutAt']?.toString(),
      payout: (json['payout'] as num?)?.toDouble(),
      status: json['status']?.toString(),
      id: json['_id']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roundId': roundId,
      'userId': userId,
      'stake': stake,
      'currency': currency,
      'autoCashout': autoCashout,
      'betIndex': betIndex,
      'placedAt': placedAt,
      'cashoutAt': cashoutAt,
      'cashedOutAt': cashedOutAt,
      'payout': payout,
      'status': status,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
