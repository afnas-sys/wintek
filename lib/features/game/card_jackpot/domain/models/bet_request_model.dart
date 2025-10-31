class BetRequestModel {
  final String roundId;
  final String userId;
  final String sessionId;
  final int points;
  final String cardNumber;

  const BetRequestModel({
    required this.roundId,
    required this.userId,
    required this.sessionId,
    required this.points,
    required this.cardNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'round_id': roundId,
      'user_id': userId,
      'session_id': sessionId,
      'points': points,
      'card_number': cardNumber,
    };
  }
}
