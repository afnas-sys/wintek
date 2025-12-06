import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/features/game/crash/providers/crash_round_provider.dart';
import 'package:wintek/features/game/crash/widgets/crash_all_bets.dart';
import 'package:wintek/features/game/crash/widgets/crash_animation.dart';
import 'package:wintek/features/game/crash/widgets/crash_bet_container.dart';
import 'package:wintek/features/game/crash/widgets/crash_my_bets.dart';
import 'package:wintek/features/game/crash/widgets/crash_recent_rounds.dart'
    show CrashRecentRoundsWidget;
import 'package:wintek/features/game/widgets/custom_tab_bar.dart';
import 'package:wintek/features/game/widgets/wallet_container.dart';

enum GameState { prepare, running, crashed }

class CrashGameScreen extends ConsumerStatefulWidget {
  const CrashGameScreen({super.key});

  @override
  ConsumerState<CrashGameScreen> createState() => _CrashGameScreenState();
}

class _CrashGameScreenState extends ConsumerState<CrashGameScreen>
    with SingleTickerProviderStateMixin {
  int _containerCount = 2;
  late AnimationController _controller;
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(); // Infinite rotation

    // Infinite rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(crashDisconnectProvider, (previous, next) {
      _messengerKey.currentState?.clearSnackBars();
      ref.read(flushbarListProvider.notifier).dismissAll();
    });

    return ScaffoldMessenger(
      key: _messengerKey,
      child: Scaffold(
        body: Stack(
          children: [
            /// 🔵 Rotating background image (only image rotates)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * 3.1416,
                  alignment: Alignment.topLeft,
                  child: Transform.scale(scale: 15, child: child),
                );
              },
              child: SizedBox.expand(
                child: Image.asset(
                  'assets/images/crash_bg.png',
                  // fit: BoxFit.cover,
                ),
              ),
            ),

            SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const WalletContainer(),
                        const SizedBox(height: 16),
                        const CrashRecentRoundsWidget(),
                        const SizedBox(height: 16),
                        SizedBox(height: 420, child: const CrashAnimation()),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _containerCount,
                          itemBuilder: (context, index) {
                            return CrashBetContainer(
                              index: index + 1,
                              //   showAddButton: index == _containerCount - 1,
                              onAddPressed: () =>
                                  setState(() => _containerCount++),
                              //   showRemoveButton:
                              // _containerCount > 1 &&
                              // index == _containerCount - 1,
                              onRemovePressed: () =>
                                  setState(() => _containerCount--),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                        ),
                        const SizedBox(height: 16),
                        CustomTabBar(
                          tabs: ['All Bets', 'My Bets'],
                          backgroundColor: AppColors.crashTwentyFirstColor,
                          borderRadius: 52,
                          borderWidth: 1,
                          borderColor: AppColors.crashTwelfthColor,
                          selectedTabColor: AppColors.crashTwelfthColor,
                          unselectedTextColor: AppColors.crashPrimaryColor,
                          tabViews: [CrashAllBets(), CrashMyBets()],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
