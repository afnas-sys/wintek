import 'package:flutter/material.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/bottum_sheet.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/core/constants/app_strings.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';

class MainCardContainer extends StatelessWidget {
  final int index;
  final int cardTypeIndex;
  const MainCardContainer({
    super.key,
    required this.index,
    required this.cardTypeIndex,
  });
  @override
  Widget build(BuildContext context) {
    final cardName = AppStrings.mainCardNames[index];
    final List<Color> gradientColors = AppColors.mainCardGradient[index];

    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xff000000).withOpacity(5 / 100),
              spreadRadius: 7,
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
          gradient: RadialGradient(
            radius: 1.5,
            colors: gradientColors,
            center: const Alignment(0.4, -0.3),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(AppImages.cardImage),
            ),
            SizedBox(width: 17),
            AppText(
              text: cardName,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
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
              cardIndex: index,
              isMainCard: true,
              cardTypeIndex: cardTypeIndex,
            );
          },
        );
      },
    );
  }
}
