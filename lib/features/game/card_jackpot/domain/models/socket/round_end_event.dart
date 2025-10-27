class RoundEndEvent {
  final String roundId;
  final String sessionId;
  final String state;
  final DateTime endedAt;
  final String winningCard;
  final List<dynamic> winners;

  RoundEndEvent({
    required this.roundId,
    required this.sessionId,
    required this.state,
    required this.endedAt,
    required this.winningCard,
    required this.winners,
  });

  factory RoundEndEvent.fromJson(Map<String, dynamic> json) => RoundEndEvent(
    roundId: json['roundId'],
    sessionId: json['sessionId'],
    state: json['state'],
    endedAt: DateTime.parse(json['endedAt']),
    winningCard: json['winningCard'],
    winners: List<dynamic>.from(json['winners']),
  );

  Map<String, dynamic> toJson() => {
    'roundId': roundId,
    'sessionId': sessionId,
    'state': state,
    'endedAt': endedAt.toIso8601String(),
    'winningCard': winningCard,
    'winners': winners,
  };

  RoundEndEvent copyWith({
    String? roundId,
    String? sessionId,
    String? state,
    DateTime? endedAt,
    String? winningCard,
    List<dynamic>? winners,
  }) {
    return RoundEndEvent(
      roundId: roundId ?? this.roundId,
      sessionId: sessionId ?? this.sessionId,
      state: state ?? this.state,
      endedAt: endedAt ?? this.endedAt,
      winningCard: winningCard ?? this.winningCard,
      winners: winners ?? this.winners,
    );
  }
}
