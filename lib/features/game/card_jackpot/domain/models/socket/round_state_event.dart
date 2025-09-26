class RoundStateEvent {
  final String roundId;
  final String sessionId;
  final String state;
  final DateTime startedAt;
  final int msRemaining;

  RoundStateEvent({
    required this.roundId,
    required this.sessionId,
    required this.state,
    required this.startedAt,
    required this.msRemaining,
  });

  factory RoundStateEvent.fromJson(Map<String, dynamic> json) =>
      RoundStateEvent(
        roundId: json['roundId'],
        sessionId: json['sessionId'],
        state: json['state'],
        startedAt: DateTime.parse(json['startedAt']),
        msRemaining: json['msRemaining'],
      );

  Map<String, dynamic> toJson() => {
    'roundId': roundId,
    'sessionId': sessionId,
    'state': state,
    'startedAt': startedAt.toIso8601String(),
    'msRemaining': msRemaining,
  };

  RoundStateEvent copyWith({
    String? roundId,
    String? sessionId,
    String? state,
    DateTime? startedAt,
    int? msRemaining,
  }) {
    return RoundStateEvent(
      roundId: roundId ?? this.roundId,
      sessionId: sessionId ?? this.sessionId,
      state: state ?? this.state,
      startedAt: startedAt ?? this.startedAt,
      msRemaining: msRemaining ?? this.msRemaining,
    );
  }
}
