import 'package:flutter/material.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/game_round/round_model.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/core/constants/app_images.dart';

// class GameHistoryTile extends StatelessWidget {
//   final BetModel bet;
//   const GameHistoryTile({super.key, required this.bet});

//   @override
//   Widget build(BuildContext context) {
//     final cardName = bet.cardName.toString() == '10'
//         ? '10'
//         : bet.cardName.toString()[0];
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: ListTile(
//         title: AppText(text: bet.id, fontSize: 14, fontWeight: FontWeight.w400),
//         trailing: Row(
//           spacing: 10,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(child: Image.asset(AppImages.kingImage)),
//             AppText(text: cardName, fontSize: 14, fontWeight: FontWeight.w400),
//           ],
//         ),
//       ),
//     );
//   }
// }
