//! State Model
class CrashRoundState {
  final String? roundId;
  final String? seq;
  final String? state;
  final String? startedAt;
  final String? msRemaining;
  final String? endedAt;
  final String? crashAt;

  CrashRoundState({
    this.roundId,
    this.seq,
    this.state,
    this.startedAt,
    this.msRemaining,
    this.endedAt,
    this.crashAt,
  });

  factory CrashRoundState.fromJson(Map<String, dynamic> json) {
    return CrashRoundState(
      roundId: json['roundId']?.toString(),
      seq: json['seq']?.toString(),
      state: json['state']?.toString(),
      startedAt: json['startedAt']?.toString(),
      msRemaining: json['msRemaining']?.toString(),
      endedAt: json['endedAt']?.toString(),
      crashAt: json['crashAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "roundId": roundId,
      "seq": seq,
      "state": state,
      "startedAt": startedAt,
      "msRemaining": msRemaining,
      "endedAt": endedAt,
      "crashAt": crashAt,
    };
  }
}

//! Tick Model
class CrashTick {
  final String? seq;
  final String? multiplier;
  final String? now;

  CrashTick({this.seq, this.multiplier, this.now});

  factory CrashTick.fromJson(Map<String, dynamic> json) {
    return CrashTick(
      seq: json['seq'].toString(),
      multiplier: json['multiplier'].toString(),
      now: json['now'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"seq": seq, "multiplier": multiplier, "now": now};
  }
}

//! Crash Model
class CrashRoundCrash {
  final String? roundId;
  final String? seq;
  final String? crashAt;

  CrashRoundCrash({this.roundId, this.seq, this.crashAt});

  factory CrashRoundCrash.fromJson(Map<String, dynamic> json) {
    return CrashRoundCrash(
      roundId: json['roundId'].toString(),
      seq: json['seq'].toString(),

      crashAt: json['crashAt'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"roundId": roundId, "seq": seq, "crashAt": crashAt};
  }
}
