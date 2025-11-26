import 'package:flutter/material.dart';
import 'package:wintek/features/game/spin_to_win/widgets/spin_to_win_game.dart';
import 'package:wintek/features/game/spin_to_win/widgets/spin_bet_button.dart';
import 'package:wintek/features/game/spin_to_win/widgets/spin_history.dart';
import 'package:wintek/features/game/widgets/wallet_container.dart';

class SpinToWinScreen extends StatefulWidget {
  const SpinToWinScreen({super.key});

  @override
  State<SpinToWinScreen> createState() => _SpinToWinScreenState();
}

class _SpinToWinScreenState extends State<SpinToWinScreen> {
  final GlobalKey<SpinToWinGameState> _slotKey = GlobalKey();

  void _onSpin() {
    _slotKey.currentState?.spin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: WalletContainer(),
              ),
              Container(
                height: 294,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/spin_bg.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Center(child: SpinToWinGame(key: _slotKey)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 10,
                  children: [
                    SpinBetButton(onSpin: _onSpin),
                    SpinHistory(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
