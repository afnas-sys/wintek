import 'package:flutter/material.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/bottum_sheet.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/utils/constants/app_colors.dart';

class CustomNumberCard extends StatelessWidget {
  final int index;
  final int cardNameIndex;
  final int selectedCardTypeIndex;
  const CustomNumberCard({
    super.key,
    required this.index,
    required this.cardNameIndex,
    required this.selectedCardTypeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(cardNameIndex < 10 ? 22 : 15.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          gradient: RadialGradient(
            center: const Alignment(0.6, -0.3),
            radius: 0.9,
            colors: AppColors.numberCardGradient[index],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xff000000).withOpacity(20 / 100),
              spreadRadius: 7,
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: AppText(
            text: cardNameIndex.toString(),
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          barrierColor: Colors.black.withOpacity(0.6),
          builder: (context) {
            return BottumSheet(
              cardIndex: cardNameIndex,
              cardTypeIndex: selectedCardTypeIndex,
            );
          },
        );
      },
    );
  }
}
