class AviatorRound {
  final String id;
  final int seq;
  final String state; // Prepare,  started and Crashed
  final double multiplier;
  final int bets;
  final int players;
  final double maxCashout;
  final DateTime startedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String serverSeedHash;
  final String serverSeed;
  final int nonce;
  final bool active;

  AviatorRound({
    required this.id,
    required this.seq,
    required this.state,
    required this.multiplier,
    required this.bets,
    required this.players,
    required this.maxCashout,
    required this.startedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.serverSeedHash,
    required this.serverSeed,
    required this.nonce,
    required this.active,
  });

  factory AviatorRound.fromJson(Map<String, dynamic> json) {
    final round = json['round'] ?? json;
    return AviatorRound(
      id: round['_id'] ?? round['id'] ?? round['roundId'] ?? '',
      seq: round['seq'] ?? 0,
      state: round['state'] ?? 'PREPARE',
      multiplier: (round['multiplier'] ?? 1.0).toDouble(),
      bets: (round['stats']?['bets'] ?? 0),
      players: round['stats']?['players'] ?? 0,
      maxCashout: (round['stats']?['maxCashout'] ?? 0).toDouble(),
      startedAt: DateTime.tryParse(round['startedAt'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(round['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(round['updatedAt'] ?? '') ?? DateTime.now(),
      serverSeedHash: round['serverSeedHash'] ?? '',
      serverSeed: round['serverSeed'] ?? '',
      nonce: round['nonce'] ?? 0,
      active: round['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "round": {
        "_id": id,
        "seq": seq,
        "state": state,
        "multiplier": multiplier,
        "stats": {"bets": bets, "players": players, "maxCashout": maxCashout},
        "startedAt": startedAt.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "serverSeedHash": serverSeedHash,
        "serverSeed": serverSeed,
        "nonce": nonce,
      },
      "active": active,
    };
  }
}

extension AviatorRoundCopy on AviatorRound {
  AviatorRound copyWithFrom(AviatorRound other) {
    return AviatorRound(
      id: other.id,
      seq: other.seq,
      state: other.state,
      multiplier: other.multiplier,
      startedAt: other.startedAt,
      createdAt: other.createdAt,
      updatedAt: other.updatedAt,
      serverSeedHash: other.serverSeedHash,
      serverSeed: other.serverSeed,
      nonce: other.nonce,
      active: other.active,
      bets: other.bets,
      players: other.players,
      maxCashout: other.maxCashout,
    );
  }
}
