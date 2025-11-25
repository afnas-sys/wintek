import 'dart:developer';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/aviator/providers/bet_reponse_provider.dart';
import 'package:wintek/features/game/aviator/providers/cashout_provider.dart';
import 'package:wintek/features/game/aviator/providers/user_provider.dart';
import 'package:wintek/features/game/crash/providers/crash_game_provider.dart';

class SpinCustomBetButton extends ConsumerStatefulWidget {
  final int index;
  final TextEditingController amountController;
  final TextEditingController? switchController;

  const SpinCustomBetButton({
    super.key,
    required this.index,
    required this.amountController,
    this.switchController,
  });

  @override
  ConsumerState<SpinCustomBetButton> createState() =>
      _SpinCustomBetButtonState();
}

class _SpinCustomBetButtonState extends ConsumerState<SpinCustomBetButton> {
  bool hasPlacedBet = false;
  bool hasAutoCashedOut = false;
  String? lastRoundId;
  double? lastMultiplier;

  final secureStorageService = SecureStorageService();

  Future<String?> getUserId() async {
    final creds = await secureStorageService.readCredentials();
    return creds.userId;
  }

  void _handleRoundCrash() {
    // Handle crash - no autoplay logic needed for now
  }

  void _handleAutoPlayContinuation() {
    // No autoplay logic needed for now
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(crashGameProvider);

    // Reset hasPlacedBet if a new round starts
    if (gameState.state == GameState.prepare && lastRoundId != 'prepare') {
      hasPlacedBet = false;
      hasAutoCashedOut = false;
      lastMultiplier = null;
      lastRoundId = 'prepare';

      // Handle crash - if we had a bet placed and round crashed
      if (lastRoundId != null && gameState.state == GameState.crashed) {
        _handleRoundCrash();
      }

      // Handle continuation after round reset
      _handleAutoPlayContinuation();
    }

    final bet = ref.watch(betResponseProvider)[widget.index];

    // Handle waiting state between placing bet and running
    final isWaitingForRound =
        hasPlacedBet && gameState.state == GameState.prepare;
    final isCashoutButton =
        hasPlacedBet && gameState.state == GameState.running;

    // Auto Cashout logic
    if (isCashoutButton && bet != null && bet.autoCashout != null) {
      final multiplier = gameState.currentMultiplier;

      // Only trigger cashout once when crossing the threshold
      if (!hasAutoCashedOut &&
          multiplier > bet.autoCashout! &&
          (lastMultiplier == null || lastMultiplier! <= bet.autoCashout!)) {
        lastMultiplier = multiplier;
        hasAutoCashedOut = true;

        // Trigger auto cashout asynchronously
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            // Small delay to ensure multiplier is stable
            await Future.delayed(const Duration(milliseconds: 50));

            final cashoutService = ref.read(cashoutServiceProvider);
            final cashout = await cashoutService.cashout(
              id: bet.id,
              cashOutAt: bet.autoCashout!,
            );
            final autoCashoutAt = cashout.cashoutAt;

            log("✅ Auto Cashout triggered at $autoCashoutAt X");

            // Update wallet after auto cashout
            final currentUser = ref.read(userProvider);
            currentUser.maybeWhen(
              data: (userModel) {
                if (userModel != null) {
                  final winAmount = autoCashoutAt! * bet.stake;
                  final newWallet = userModel.data.wallet + winAmount;
                  ref.read(userProvider.notifier).updateWallet(newWallet);
                }
              },
              orElse: () {},
            );

            if (mounted) {
              setState(() {
                hasPlacedBet = false;
              });
            }

            // Show Flushbar
            _successFlushbar(
              context: context,
              message1: "Auto Cashout at!\n",
              multiplier: '$autoCashoutAt X',
              message2: 'Win INR\n',
              winAmount: (autoCashoutAt! * bet.stake).toStringAsFixed(2),
            );
          } catch (e) {
            log("❌ Auto Cashout failed: $e");
            hasAutoCashedOut = false; // Reset if fails
          }
        });
      }

      lastMultiplier = multiplier;
    }

    final buttonText = !hasPlacedBet
        ? "BET"
        : isCashoutButton
        ? "CASHOUT"
        : isWaitingForRound
        ? "WAITING"
        : "BET";

    // final enabled = !hasPlacedBet || isCashoutButton;

    return SizedBox(
      height: 200,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (!hasPlacedBet) {
              return AppColors.crashFifteenthColor; // initial Place Bet
            } else if (hasPlacedBet && gameState.state == GameState.running) {
              return AppColors.crashFourteenthColor; // CASHOUT
            } else if (gameState.state == GameState.crashed) {
              return AppColors.crashFourteenthColor;
            } else {
              return AppColors.crashTwentyFourthColor; // Bet placed but waiting
            }
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          ),
          minimumSize: MaterialStateProperty.all(const Size(55, 30)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),

        onPressed: () {},

        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.crashHeadlineSmall,
        ),
      ),
    );
  }

  // Success Flushbar
  void _successFlushbar({
    required BuildContext context,
    required String message1,
    required String multiplier,
    required String message2,
    required String winAmount,
  }) {
    Flushbar(
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: message1,
                      style: TextStyle(
                        color: AppColors.crashThirteenthColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: multiplier,
                      style: TextStyle(
                        color: AppColors.crashPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.crashFifteenthColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: message2,
                        style: TextStyle(
                          color: AppColors.crashThirteenthColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: winAmount,
                        style: TextStyle(
                          color: AppColors.crashPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      backgroundColor: AppColors.crashTwentyFifthColor,
      margin: const EdgeInsets.all(2.0),
      borderWidth: 2,
      borderColor: AppColors.crashFifteenthColor,
      duration: const Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      borderRadius: BorderRadius.circular(50),
      animationDuration: const Duration(seconds: 1),
      maxWidth: 300,
    ).show(context);
  }
}
