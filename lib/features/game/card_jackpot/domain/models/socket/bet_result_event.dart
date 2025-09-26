class BetResultEvent {
  final String roundId;
  final String winningCard;
  final List<dynamic> winners;
  final int totalBets;
  final int totalWinnings;

  BetResultEvent({
    required this.roundId,
    required this.winningCard,
    required this.winners,
    required this.totalBets,
    required this.totalWinnings,
  });

  factory BetResultEvent.fromJson(Map<String, dynamic> json) => BetResultEvent(
    roundId: json['roundId'],
    winningCard: json['winningCard'],
    winners: List<dynamic>.from(json['winners']),
    totalBets: json['totalBets'],
    totalWinnings: json['totalWinnings'],
  );

  Map<String, dynamic> toJson() => {
    'roundId': roundId,
    'winningCard': winningCard,
    'winners': winners,
    'totalBets': totalBets,
    'totalWinnings': totalWinnings,
  };

  BetResultEvent copyWith({
    String? roundId,
    String? winningCard,
    List<dynamic>? winners,
    int? totalBets,
    int? totalWinnings,
  }) {
    return BetResultEvent(
      roundId: roundId ?? this.roundId,
      winningCard: winningCard ?? this.winningCard,
      winners: winners ?? this.winners,
      totalBets: totalBets ?? this.totalBets,
      totalWinnings: totalWinnings ?? this.totalWinnings,
    );
  }
}
