import 'package:flutter/material.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/bottum_sheet.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/core/constants/app_colors.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerSize = screenWidth < 400 || screenHeight < 600 ? 55 : 60;
    double fontSize = screenWidth < 400 || screenHeight < 600 ? 23 : 25;
    return InkWell(
      child: Container(
        width: containerSize,
        height: containerSize,
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
        child: Stack(
          children: [
            Center(
              child: AppText(
                text: cardNameIndex.toString(),
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
