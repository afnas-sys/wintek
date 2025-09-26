class RoundEvent {
  final String? roundId;
  final String? sessionId;
  final String? state; // RUNNING, PREPARE, ENDED
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? duration;
  final int? msRemaining;
  final String? winningCard;
  final List<dynamic>? winners;

  RoundEvent({
    this.roundId,
    this.sessionId,
    this.state,
    this.startedAt,
    this.endedAt,
    this.duration,
    this.msRemaining,
    this.winningCard,
    this.winners,
  });

  factory RoundEvent.fromJson(Map<String, dynamic> json) => RoundEvent(
    roundId: json['roundId'],
    sessionId: json['sessionId'],
    state: json['state'],
    startedAt: json['startedAt'] != null
        ? DateTime.parse(json['startedAt'])
        : null,
    endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt']) : null,
    duration: json['duration'],
    msRemaining: json['msRemaining'] ?? 0,
    winningCard: json['winningCard'],
    // winners: (json['winners'] as List?)?.map((e) => e.toString()).toList(),
  );

  Map<String, dynamic> toJson() => {
    "roundId": roundId,
    "sessionId": sessionId,
    "state": state,
    "startedAt": startedAt?.toIso8601String(),
    "endedAt": endedAt?.toIso8601String(),
    "duration": duration,
    "msRemaining": msRemaining,
    "winningCard": winningCard,
    "winners": winners,
  };

  RoundEvent copyWith({
    String? roundId,
    String? sessionId,
    String? state,
    DateTime? startedAt,
    DateTime? endedAt,
    int? duration,
    int? msRemaining,
    String? winningCard,
    List<dynamic>? winners,
  }) {
    return RoundEvent(
      roundId: roundId ?? this.roundId,
      sessionId: sessionId ?? this.sessionId,
      state: state ?? this.state,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
      msRemaining: msRemaining ?? this.msRemaining,
      winningCard: winningCard ?? this.winningCard,
      winners: winners ?? this.winners,
    );
  }
}
