// ignore_for_file: file_names

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/aviator/domain/models/bet_request.dart';
import 'package:wintek/features/game/aviator/providers/aviator_round_provider.dart';
import 'package:wintek/features/game/aviator/providers/bet_provider.dart';
import 'package:wintek/features/game/aviator/providers/waiting_provider.dart';

class CustomBetButton extends ConsumerWidget {
  final int index; // pass 1 or 2 (API expected)
  final TextEditingController amountController;

  CustomBetButton({
    super.key,
    required this.index,
    required this.amountController,
  });

  final secureStorageService = SecureStorageService();

  Future<String?> getUserId() async {
    final creds = await secureStorageService.readCredentials();
    return creds.userId;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = ref.watch(aviatorRoundNotifierProvider);
    final betStatusMap = ref.watch(betStateProvider);
    final waitingMap = ref.watch(waitingForNextRoundProvider);
    final isWaiting = waitingMap[index] ?? false;
    final status = betStatusMap[index] ?? BetStatus.none;
    final isBetPlaced = status == BetStatus.placed;

    // decide label + enabled state
    String buttonText;
    bool enabled;

    if (isWaiting) {
      buttonText = " Waiting for next round...";
      enabled = true;
    } else {
      // default label logic: if placed -> Cancel, otherwise Place Bet
      buttonText = "Place Bet";

      // enabled if round state is PREPARE, RUNNING, or CASHOUT
      enabled =
          round != null &&
          (round.state == 'PREPARE' ||
              round.state == 'RUNNING' ||
              round.state == 'CRASHED');
    }

    return SizedBox(
      height: 108,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isWaiting
              ? Color(0XFFcb001b)
              : AppColors.aviatorEighteenthColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          minimumSize: const Size(55, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: enabled
            ? () async {
                // If user tried to place bet during RUNNING and they don't yet have a placed bet:
                if (round?.state == "RUNNING" && !isBetPlaced) {
                  log(
                    'User attempted to place during RUNNING — showing waiting state for index $index',
                  );
                  ref
                      .read(waitingForNextRoundProvider.notifier)
                      .setWaiting(index);
                  return; // do not call API
                }

                // Normal place or cancel flow
                if (!isBetPlaced) {
                  // PLACE BET (only when not RUNNING or when allowed)
                  final betService = ref.read(betServiceProvider);
                  final userId = await getUserId();

                  log(
                    'Placing bet: roundId=${round?.roundId}, userId=$userId, seq=${round?.seq}, stake=${amountController.text}, betIndex=$index',
                  );

                  if (userId == null) {
                    log('❌ No userId found!');
                    return;
                  }

                  try {
                    final bet = await betService.placeBet(
                      BetRequest(
                        roundId: '${round?.roundId}',
                        userId: userId,
                        seq: int.parse('${round?.seq}'),
                        stake: int.parse(amountController.text),
                        betIndex: index,
                      ),
                    );

                    log('✅ Bet placed successfully: ${bet.stake}');
                    // update bet status (persisted by riverpod)
                    ref.read(betStateProvider.notifier).placeBet(index);
                    // ensure waiting flag cleared for this index
                    ref
                        .read(waitingForNextRoundProvider.notifier)
                        .clearWaiting(index);
                  } catch (e) {
                    log('❌ Error placing bet: $e');
                  }
                } else {
                  // CANCEL BET (local only)
                  log('⚠️ Bet cancelled by user (index $index)');
                  ref.read(betStateProvider.notifier).cancelBet(index);
                  // also clear waiting if any
                  ref
                      .read(waitingForNextRoundProvider.notifier)
                      .clearWaiting(index);
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
