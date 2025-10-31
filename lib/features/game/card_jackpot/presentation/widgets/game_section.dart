import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/bottum_history_tab.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/cards_section.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/timer_section.dart';
import 'package:wintek/features/game/card_jackpot/providers/history_provider.dart';
import 'package:wintek/features/game/card_jackpot/providers/round_provider.dart';
import 'package:wintek/features/game/card_jackpot/providers/time_provider.dart';
import 'package:wintek/features/game/card_jackpot/providers/wallet_provider.dart';
import 'package:wintek/core/constants/app_icons.dart';
import 'package:wintek/core/constants/app_strings.dart';
import 'package:wintek/core/constants/app_colors.dart';

class GameTabs extends ConsumerStatefulWidget {
  const GameTabs({super.key});

  @override
  ConsumerState<GameTabs> createState() => _GameTabsState();
}

class _GameTabsState extends ConsumerState<GameTabs> {
  int selectedCardTypeIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(cardSocketProvider);
      ref.watch(walletBalanceProvider);
      ref.watch(gameHistoryProvider.notifier).fetchGameHistory();
      ref.watch(myHistoryProvider.notifier).fetchMyHistory();
      ref.read(timerProvider.notifier).start();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tabs Container
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(AppStrings.tabsNames.length, (index) {
              final isSelected = index == selectedCardTypeIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => selectedCardTypeIndex = index);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: !isSelected ? Colors.transparent : null,
                      gradient: isSelected
                          ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFB1A1FF), Color(0xFF5134E5)],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(
                              color: AppColors.gameTabContainerBorderColor,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(0x33FFFFFF)
                                  : Color(0x1AAA99FD),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              AppIcons.tabIcons[index],
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.gameTabContainerBorderColor,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            AppStrings.tabsNames[index],
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.cardSecondPrimaryColor
                                  : AppColors.gameTabContainerBorderColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Column(
            key: ValueKey(selectedCardTypeIndex),
            children: [
              // The Three minutes of the timer section for each round of card play
              TimerSection(),
              SizedBox(height: 10),

              // The widget includes main 4 cards and other 9 numbers of cards
              // The widget inclues 2 other sub widgets for main cards and numbers
              // Cards Section widget passing index for the main 4 types
              CardsSection(selectedCardTypeIndex: selectedCardTypeIndex),

              SizedBox(height: 5),

              //  A devider added for the supperation history and the game section
              Divider(),
              SizedBox(height: 5),
              // This is the part of History of the game
              // It containes Two buttons for Game History and My histroy
              BottumHistoryTab(),
            ],
          ),
        ),
      ],
    );
  }
}
