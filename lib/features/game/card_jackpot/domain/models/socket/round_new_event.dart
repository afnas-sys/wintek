class RoundNewEvent {
  final String roundId;
  final String sessionId;
  final String state;
  final DateTime startedAt;
  final int duration;
  final int msRemaining;

  RoundNewEvent({
    required this.roundId,
    required this.sessionId,
    required this.state,
    required this.startedAt,
    required this.duration,
    required this.msRemaining,
  });

  factory RoundNewEvent.fromJson(Map<String, dynamic> json) => RoundNewEvent(
    roundId: json['roundId'],
    sessionId: json['sessionId'],
    state: json['state'],
    startedAt: DateTime.parse(json['startedAt']),
    duration: json['duration'],
    msRemaining: json['msRemaining'],
  );

  Map<String, dynamic> toJson() => {
    'roundId': roundId,
    'sessionId': sessionId,
    'state': state,
    'startedAt': startedAt.toIso8601String(),
    'duration': duration,
    'msRemaining': msRemaining,
  };

  RoundNewEvent copyWith({
    String? roundId,
    String? sessionId,
    String? state,
    DateTime? startedAt,
    int? duration,
    int? msRemaining,
  }) {
    return RoundNewEvent(
      roundId: roundId ?? this.roundId,
      sessionId: sessionId ?? this.sessionId,
      state: state ?? this.state,
      startedAt: startedAt ?? this.startedAt,
      duration: duration ?? this.duration,
      msRemaining: msRemaining ?? this.msRemaining,
    );
  }
}
