import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/aviator/widget/all_bets.dart';
import 'package:wintek/features/game/aviator/widget/aviator_buttons.dart';
import 'package:wintek/features/game/aviator/widget/balance_container.dart';
import 'package:wintek/features/game/aviator/widget/bet_container_.dart';
import 'package:wintek/features/game/aviator/widget/custom_tab_bar.dart';
import 'package:wintek/features/game/aviator/widget/graph_container.dart';
import 'package:wintek/features/game/aviator/widget/my_bets.dart';
import 'package:wintek/features/game/aviator/widget/top.dart';
import 'package:wintek/core/constants/app_colors.dart';

class AviatorGameScreen extends ConsumerStatefulWidget {
  const AviatorGameScreen({super.key});

  @override
  ConsumerState<AviatorGameScreen> createState() => _AviatorGameScreenState();
}

class _AviatorGameScreenState extends ConsumerState<AviatorGameScreen> {
  @override
  Widget build(BuildContext context) {
    //   final roundState = ref.watch(aviatorRoundNotifierProvider);
    // final roundState = ref.watch();
    // final tickEvent = ref.watch();
    // final crashEvent = ref.watch(aviatorCrashProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // roundState.when(
                //   data: (round) => Center(
                //     child: Text(
                //       'state: ${round.state}\n Round id: ${round.roundId},\n Seq: ${round.seq}, \nstart AT: ${round.startedAt},\nmsRemaining: ${round.msRemaining}, \nended AT: ${round.endedAt}, \nCrash at: ${round.crashAt},',
                //       style: TextStyle(
                //         color: AppColors.textPrimaryColor,
                //         fontSize: 20,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                //   error: (error, st) => Text(error.toString()),
                //   loading: () => CircularProgressIndicator(),
                // ),
                // SizedBox(height: 16),
                // tickEvent.when(
                //   data: (event) => Text(
                //     'seq: ${event.seq}, \nmultiplier: ${event.multiplier}, \nnow: ${event.now},',
                //     style: TextStyle(
                //       color: AppColors.textPrimaryColor,
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   error: (error, st) => Text(error.toString()),
                //   loading: () => CircularProgressIndicator(),
                // ),
                // SizedBox(height: 16),
                // crashEvent.when(
                //   data: (event) => Text(
                //     'RoundId ${event.roundId},\n seq ${event.seq},\n Crash at ${event.crashAt}',
                //     style: TextStyle(
                //       color: AppColors.textPrimaryColor,
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   error: (error, st) => Text(error.toString()),
                //   loading: () => CircularProgressIndicator(),
                // ),
                BalanceContainer(),
                SizedBox(height: 16),
                AviatorButtons(),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(
                    //   roundState.when(
                    //     data: (round) => round.roundId!,
                    //     error: (error, st) => error.toString(),
                    //     loading: () => '',
                    //   ),
                    //   style: Theme.of(
                    //     context,
                    //   ).textTheme.aviatorbodySmallPrimary,
                    // ),
                    // Text(
                    //   roundState.when(
                    //     data: (round) => round.roundId!,
                    //     error: (error, st) => error.toString(),
                    //     loading: () => '',
                    //   ),
                    //   style: Theme.of(
                    //     context,
                    //   ).textTheme.aviatorbodySmallPrimary,
                    // ),
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
                    return BetContainer(
                      index:
                          index +
                          1, // Convert 0-based list index to 1-based API index
                    );
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
