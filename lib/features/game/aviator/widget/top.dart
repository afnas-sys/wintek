import 'package:flutter/material.dart';
import 'package:wintek/features/game/aviator/widget/custom_tab_bar.dart';
import 'package:wintek/features/game/aviator/widget/day_widget.dart';
import 'package:wintek/features/game/aviator/widget/month_widget.dart';
import 'package:wintek/features/game/aviator/widget/year_widget.dart';
import 'package:wintek/utils/app_colors.dart';

class Top extends StatefulWidget {
  const Top({super.key});

  @override
  State<Top> createState() => _TopState();
}

class _TopState extends State<Top> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bgTenthColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CustomTabBar(
            tabs: ['Day', 'Month', 'Year'],
            backgroundColor: AppColors.bgSeventeenthColor,
            borderRadius: 52,
            borderWidth: 1,
            borderColor: AppColors.borderThirdColor,
            selectedTabColor: AppColors.tabBarSelectedColor,
            unselectedTextColor: AppColors.textPrimaryColor,
            tabViews: [DayWidget(), MonthWidget(), YearWidget()],
          ),
        ],
      ),
    );
  }
}
