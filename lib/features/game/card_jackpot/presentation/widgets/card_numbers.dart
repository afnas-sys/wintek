import 'package:flutter/material.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/number_card.dart';
import 'package:wintek/core/constants/app_colors.dart';

class NumbersCards extends StatelessWidget {
  final int selectedCardTypeIndex;
  const NumbersCards({super.key, required this.selectedCardTypeIndex});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(vertical: 19),
      decoration: BoxDecoration(
        // color: AppColors.cardPrimaryColor,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB1A1FF), AppColors.cardPrimaryColor],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              int ind = 10 - index;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomNumberCard(
                  index: index,
                  cardNameIndex: ind,
                  selectedCardTypeIndex: selectedCardTypeIndex,
                ),
              );
            }),
          ),
          SizedBox(height: 19),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: List.generate(4, (index) {
              int cardNameIndex = 5 - index;
              int numberPositionIndex = index + 5;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomNumberCard(
                  index: numberPositionIndex,
                  cardNameIndex: cardNameIndex,
                  selectedCardTypeIndex: selectedCardTypeIndex,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
