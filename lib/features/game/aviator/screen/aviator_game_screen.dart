import 'package:flutter/material.dart';
import 'package:wintek/features/game/aviator/widget/all_bets.dart';
import 'package:wintek/features/game/aviator/widget/aviator_buttons.dart';
import 'package:wintek/features/game/aviator/widget/balance_container.dart';
import 'package:wintek/features/game/aviator/widget/bet_container_.dart';
import 'package:wintek/features/game/aviator/widget/custom_tab_bar.dart';
import 'package:wintek/features/game/aviator/widget/graph_container.dart';
import 'package:wintek/features/game/aviator/widget/my_bets.dart';
import 'package:wintek/features/game/aviator/widget/top.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';

class AviatorGameScreen extends StatefulWidget {
  const AviatorGameScreen({super.key});

  @override
  State<AviatorGameScreen> createState() => _AviatorGameScreenState();
}

class _AviatorGameScreenState extends State<AviatorGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                BalanceContainer(),
                SizedBox(height: 16),
                AviatorButtons(),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Round ID: 436963',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorbodySmallPrimary,
                    ),
                    Text(
                      'Round ID: 436963',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorbodySmallPrimary,
                    ),
                  ],
                ),
                SizedBox(height: 1),
                GraphContainer(),
                SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return BetContainer(index: index);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 16);
                  },
                ),
                // BetContainer(),
                // SizedBox(height: 16),
                // BetContainer(),
                SizedBox(height: 20),
                CustomTabBar(
                  tabs: ['All Bets', 'My Bets', 'Top'],
                  backgroundColor: AppColors.aviatorTwentiethColor,
                  borderRadius: 52,
                  borderWidth: 1,
                  borderColor: AppColors.aviatorFifteenthColor,
                  selectedTabColor: AppColors.aviatorFifteenthColor,
                  unselectedTextColor: AppColors.aviatorTertiaryColor,
                  tabViews: [AllBets(), MyBets(), Top()],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
