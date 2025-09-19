class BetRequest {
  final String roundId;
  final String userId;
  final int seq;
  final double stake;
  final double? autoCashout;
  final int betIndex;

  BetRequest({
    required this.roundId,
    required this.userId,
    required this.seq,
    required this.stake,
    this.autoCashout,
    required this.betIndex,
  });

  // factory BetRequest.fromJson(Map<String, dynamic> json) {
  //   return BetRequest(
  //     roundId: json['roundId'] as String,
  //     userId: json['userId'] as String,
  //     seq: json['seq'] as int,
  //     stake: (json['stake'] as num).toDouble(),
  //     autoCashout: json['autoCashout'] != null
  //         ? (json['autoCashout'] as num).toDouble()
  //         : null,
  //     betIndex: json['betIndex'] as int,
  //   );
  // }
  factory BetRequest.fromJson(Map<String, dynamic> json) {
    return BetRequest(
      roundId: json['roundId'] as String,
      userId: json['userId'] as String,
      seq: json['seq'] as int,
      stake: (json['stake'] as num).toDouble(),
      autoCashout: json['auto_cashout'] != null
          ? (json['auto_cashout'] as num).toDouble()
          : null,
      betIndex: json['betIndex'] as int,
    );
  }

  //   Map<String, dynamic> toJson() {
  //     return {
  //       "roundId": roundId,
  //       "userId": userId,
  //       "seq": seq,
  //       "stake": stake,
  //       if (autoCashout != null)
  //         "autoCashout": autoCashout, // only add if not null
  //       "betIndex": betIndex,
  //     };
  //   }
  // }
  Map<String, dynamic> toJson() {
    return {
      "roundId": roundId,
      "userId": userId,
      "seq": seq,
      "stake": stake,
      if (autoCashout != null) "auto_cashout": autoCashout,
      "betIndex": betIndex,
    };
  }
}
