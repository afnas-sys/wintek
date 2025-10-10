// ignore_for_file: file_names

import 'dart:developer';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/aviator/domain/models/bet_request.dart';
import 'package:wintek/features/game/aviator/providers/aviator_round_provider.dart';
import 'package:wintek/features/game/aviator/providers/bet_provider.dart';
import 'package:wintek/features/game/aviator/providers/bet_reponse_provider.dart';
import 'package:wintek/features/game/aviator/providers/cashout_provider.dart';

class CustomBetButton extends ConsumerStatefulWidget {
  final int index;
  final TextEditingController amountController;
  final TextEditingController? switchController;

  const CustomBetButton({
    super.key,
    required this.index,
    required this.amountController,
    this.switchController,
  });

  @override
  ConsumerState<CustomBetButton> createState() => _CustomBetButtonState();
}

class _CustomBetButtonState extends ConsumerState<CustomBetButton> {
  bool hasPlacedBet = false;
  bool hasAutoCashedOut = false;
  String? lastRoundId;
  double? lastMultiplier;

  final secureStorageService = SecureStorageService();

  Future<String?> getUserId() async {
    final creds = await secureStorageService.readCredentials();
    return creds.userId;
  }

  @override
  Widget build(BuildContext context) {
    final round = ref.watch(aviatorRoundNotifierProvider);
    final tick = ref.watch(aviatorTickProvider);

    // Reset hasPlacedBet if a new round starts
    if (round != null && round.roundId != lastRoundId) {
      hasPlacedBet = false;
      hasAutoCashedOut = false;
      lastMultiplier = null;
      lastRoundId = round.roundId;
    }

    final bet = ref.watch(betResponseProvider)[widget.index];

    // Handle waiting state between placing bet and running
    final isWaitingForRound = hasPlacedBet && round?.state == 'PREPARE';
    final isCashoutButton = hasPlacedBet && round?.state == 'RUNNING';

    // Auto Cashout logic
    if (isCashoutButton && bet != null && bet.autoCashout != null) {
      tick.whenData((tickData) async {
        final multiplier =
            double.tryParse(tickData.multiplier.toString()) ?? 0.0;

        // Only trigger cashout once when crossing the threshold
        if (!hasAutoCashedOut &&
            multiplier > bet.autoCashout! &&
            (lastMultiplier == null || lastMultiplier! <= bet.autoCashout!)) {
          lastMultiplier = multiplier;
          hasAutoCashedOut = true;

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
        }

        lastMultiplier = multiplier;
      });
    }

    final buttonText = !hasPlacedBet
        ? "BET"
        : isCashoutButton
        ? "CASHOUT"
        : isWaitingForRound
        ? "WAITING"
        : "BET";

    final enabled = !hasPlacedBet || isCashoutButton;

    return SizedBox(
      height: 108,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (!hasPlacedBet) {
              return AppColors.aviatorEighteenthColor; // initial Place Bet
            } else if (hasPlacedBet && round?.state == 'RUNNING') {
              return AppColors.aviatorSeventeenthColor; // CASHOUT
            } else if (round?.state == 'CRASHED') {
              return AppColors.aviatorSeventeenthColor;
            } else {
              return AppColors
                  .aviatorTwentySixthColor; // Bet placed but waiting
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

        onPressed: enabled
            ? () async {
                final betService = ref.read(betServiceProvider);
                final userId = await getUserId();

                if (userId == null) {
                  log('❌ No userId found!');
                  return;
                }

                // Place Bet
                if (!hasPlacedBet && round != null) {
                  if (round.state == 'RUNNING') {
                    _customSnackBar(
                      context,
                      'You cannot place a bet while the game is running',
                    );
                    return;
                  }
                  final amountText = widget.amountController.text.trim();
                  final autoCashoutText =
                      widget.switchController?.text.trim() ?? '';

                  final autoCashoutValue = autoCashoutText.isNotEmpty
                      ? double.tryParse(autoCashoutText)
                      : null;
                  if (amountText.isEmpty) {
                    log('⚠️ Bet amount is empty');
                    return;
                  }
                  final roundId = round.roundId;
                  final seq = round.seq;

                  try {
                    final newBet = await betService.placeBet(
                      BetRequest(
                        roundId: roundId!,
                        userId: userId,
                        seq: int.parse(seq.toString()),
                        stake: int.parse(amountText),
                        betIndex: widget.index,
                        autoCashout: autoCashoutValue,
                      ),
                    );

                    if (newBet != null) {
                      ref
                          .read(betResponseProvider.notifier)
                          .setBetResponse(widget.index, newBet);

                      ref
                          .read(betStateProvider.notifier)
                          .placeBet(widget.index);

                      setState(() {
                        hasPlacedBet = true;
                      });

                      log('✅ Bet placed successfully: ${newBet.stake}');
                    }
                  } on DioException catch (e) {
                    final errorMsg =
                        e.response?.data?['message'] ?? 'Bet failed';
                    log('❌ Error placing bet: $errorMsg');
                    // Show error in
                    _customSnackBar(context, errorMsg);
                  } catch (e) {
                    log('❌ Error placing bet: $e');
                    _customSnackBar(
                      context,
                      'Something went wrong. Please try again.',
                    );
                  }
                }
                // Cashout
                else if (isCashoutButton && bet != null) {
                  final cashoutService = ref.read(cashoutServiceProvider);
                  final multiplier = tick.maybeWhen(
                    data: (tick) {
                      final value = tick.multiplier;
                      if (value is num) {
                        return double.tryParse(value.toString()) ?? 0.0;
                      }
                      if (value is String) return double.tryParse(value) ?? 0.0;
                      return 0.0;
                    },
                    orElse: () => 0.0,
                  );
                  // Auto Cashout check
                  if (!hasAutoCashedOut &&
                      bet.autoCashout != null &&
                      multiplier >= bet.autoCashout!) {
                    hasAutoCashedOut = true; // mark as done
                    //   final cashoutService = ref.read(cashoutServiceProvider);

                    // try {
                    //   final response = await cashoutService.cashout(
                    //     id: bet.id,
                    //     cashOutAt: multiplier,
                    //   );
                    //   log(
                    //     "✅ Auto Cashout triggered at ${response.cashoutAt} X",
                    //   );
                    //   setState(() {
                    //     hasPlacedBet = false; // reset button if needed
                    //   });
                    // } catch (e) {
                    //   log("❌ Auto Cashout failed: $e");
                    // }
                  }

                  try {
                    log(
                      "📤 Cashout request: id=${bet.id}, cashOutAt=$multiplier",
                    );

                    // Small delay to ensure multiplier is stable
                    //      await Future.delayed(const Duration(milliseconds: 50));
                    final response = await cashoutService.cashout(
                      id: bet.id,
                      cashOutAt: multiplier,
                    );
                    if (mounted) {
                      setState(() {
                        hasPlacedBet = false;
                      });
                    }
                    final cashoutAt = response.cashoutAt;
                    log('✅ CashoutAt: $cashoutAt X');

                    // ✅ show Flushbar only if success
                    _successFlushbar(
                      context: context,
                      message1: "You Have Crashed\nout!",
                      multiplier: '\n$cashoutAt X',
                      message2: "Win INR\n",
                      winAmount: (cashoutAt! * bet.stake).toStringAsFixed(2),
                    );
                  } catch (e, st) {
                    log("❌ Cashout error: $e\n$st");
                  }
                }
              }
            : null,
        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.aviatorHeadlineSmall,
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
                        color: AppColors.aviatorSixteenthColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: multiplier,
                      style: TextStyle(
                        color: AppColors.aviatorTertiaryColor,
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
                color: AppColors.aviatorEighteenthColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: message2,
                        style: TextStyle(
                          color: AppColors.aviatorSixteenthColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: winAmount,
                        style: TextStyle(
                          color: AppColors.aviatorTertiaryColor,
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

      backgroundColor: AppColors.aviatorTwentySeventhColor,
      margin: const EdgeInsets.all(2.0),
      borderWidth: 2,
      borderColor: AppColors.aviatorEighteenthColor,
      duration: const Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      borderRadius: BorderRadius.circular(50),
      animationDuration: const Duration(seconds: 1),
      maxWidth: 300,
    ).show(context);
  }

  // Custom SnackBar
  void _customSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.aviatorTwentySixthColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
