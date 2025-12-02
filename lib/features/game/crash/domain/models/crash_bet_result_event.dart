// class CrashBetResultEvent {
//   final String? roundId;
//   final String? winningCard;
//   final List<dynamic>? winners;
//   final int? totalBets;
//   final int? totalWinnings;

//   CrashBetResultEvent({
//     this.roundId,
//     this.winningCard,
//     this.winners,
//     this.totalBets,
//     this.totalWinnings,
//   });

//   factory CrashBetResultEvent.fromJson(Map<String, dynamic> json) {
//     return CrashBetResultEvent(
//       roundId: json['roundId'],
//       winningCard: json['winningCard'],
//       winners: json['winners'] != null
//           ? List<dynamic>.from(json['winners'])
//           : [],
//       totalBets: json['totalBets'],
//       totalWinnings: json['totalWinnings'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'roundId': roundId,
//     'winningCard': winningCard,
//     'winners': winners,
//     'totalBets': totalBets,
//     'totalWinnings': totalWinnings,
//   };
// }
