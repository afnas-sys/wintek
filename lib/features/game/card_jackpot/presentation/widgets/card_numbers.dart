import 'package:flutter/material.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/number_card.dart';
import 'package:wintek/utils/constants/app_colors.dart';

class NumbersCards extends StatelessWidget {
  final int selectedCardTypeIndex;
  const NumbersCards({super.key, required this.selectedCardTypeIndex});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int firstRowLength = 5;
        int secondRowLength = 4;
        if (constraints.maxWidth < 500) {
          firstRowLength = 4;
          secondRowLength = 4;
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.cardPrimaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(firstRowLength, (index) {
                  int ind = 10 - index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ), // only horizontal
                    child: CustomNumberCard(
                      index: index,
                      cardNameIndex: ind,
                      selectedCardTypeIndex: selectedCardTypeIndex,
                    ),
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(secondRowLength, (index) {
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
      },
    );
  }
}
