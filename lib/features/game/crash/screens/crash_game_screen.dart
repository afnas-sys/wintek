import 'package:flutter/material.dart';
import 'package:wintek/features/game/crash/widgets/crash_animation.dart';
import 'package:wintek/features/game/crash/widgets/crash_balance_container.dart';
import 'package:wintek/features/game/crash/widgets/crash_bet_container.dart';
import 'package:wintek/features/game/crash/widgets/crash_buttons.dart'
    show CrashButtons;

enum GameState { prepare, running, crashed }

class CrashGameScreen extends StatefulWidget {
  const CrashGameScreen({super.key});

  @override
  State<CrashGameScreen> createState() => _CrashGameScreenState();
}

class _CrashGameScreenState extends State<CrashGameScreen> {
  int _containerCount = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 16,
              children: [
                CrashBalanceContainer(),
                CrashButtons(),
                CrashAnimation(),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _containerCount,
                  itemBuilder: (context, index) {
                    return CrashBetContainer(
                      index: index + 1,
                      showAddButton: index == _containerCount - 1,
                      onAddPressed: () => setState(() => _containerCount++),
                      showRemoveButton:
                          _containerCount > 1 && index == _containerCount - 1,
                      onRemovePressed: () => setState(() => _containerCount--),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 16);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
