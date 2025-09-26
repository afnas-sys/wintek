// ignore_for_file: file_names

import 'dart:developer';
import 'package:another_flushbar/flushbar.dart';
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
  final int index; // pass 1 or 2 (API expected)
  final TextEditingController amountController;

  const CustomBetButton({
    super.key,
    required this.index,
    required this.amountController,
  });

  @override
  ConsumerState<CustomBetButton> createState() => _CustomBetButtonState();
}

class _CustomBetButtonState extends ConsumerState<CustomBetButton> {
  bool hasPlacedBet = false;
  String? lastRoundId;

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
      lastRoundId = round.roundId;
    }

    final bet = ref.watch(betResponseProvider)[widget.index];

    // Handle waiting state between placing bet and running
    final isWaitingForRound = hasPlacedBet && round?.state == 'PREPARE';
    final isCashoutButton = hasPlacedBet && round?.state == 'RUNNING';

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
                    Flushbar(
                      messageText: Text(
                        ' You cannot place a bet while the game is running',
                        style: const TextStyle(
                          color: AppColors.aviatorTertiaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      backgroundColor: AppColors.aviatorTwentySixthColor,
                      margin: const EdgeInsets.all(16.0),
                      duration: const Duration(seconds: 1),
                      flushbarPosition: FlushbarPosition.TOP,
                      flushbarStyle: FlushbarStyle.FLOATING,
                      borderRadius: BorderRadius.circular(20),
                      animationDuration: const Duration(seconds: 1),
                    ).show(context);
                    return;
                  }
                  final amountText = widget.amountController.text.trim();
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
                  } catch (e) {
                    log('❌ Error placing bet: $e');
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

                  try {
                    log(
                      "📤 Cashout request: id=${bet.id}, cashOutAt=$multiplier",
                    );

                    final cashout = await cashoutService.cashout(
                      id: bet.id,
                      cashOutAt: multiplier, // ✅ send current multiplier safely
                    );
                    log("✅ Cashout success: ${cashout.toJson()}");
                  } catch (e) {
                    log("❌ Cashout error: $e");
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
}
