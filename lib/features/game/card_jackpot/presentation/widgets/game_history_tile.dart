import 'package:flutter/material.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';

class GameHistoryTile extends StatelessWidget {
  final String period;
  final String result;
  const GameHistoryTile({
    super.key,
    required this.period,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: AppText(text: period, fontSize: 14, fontWeight: FontWeight.w400),
        trailing: AppText(
          text: result,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
