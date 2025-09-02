import 'package:flutter/material.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/main_card_container.dart';

class MainCards extends StatelessWidget {
  final int selectedCardTypeIndex;
  const MainCards({super.key, required this.selectedCardTypeIndex});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 13,
        mainAxisSpacing: 13,
      ),
      itemBuilder: (context, cardNameIndex) {
        return MainCardContainer(
          index: cardNameIndex,
          cardTypeIndex: selectedCardTypeIndex,
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 4,
    );
  }
}
