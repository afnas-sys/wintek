import 'dart:developer';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/crash/domain/models/crash_bet_request_model.dart';
import 'package:wintek/features/game/crash/domain/models/crash_round_model.dart';
import 'package:wintek/features/game/crash/providers/crash_bet_provider.dart';
import 'package:wintek/features/game/crash/providers/crash_auto_cashout_provider.dart';
import 'package:wintek/features/game/crash/providers/crash_bet_response_provider.dart';
import 'package:wintek/features/game/crash/providers/crash_cashout_provider.dart';
import 'package:wintek/features/game/crash/providers/crash_round_provider.dart';
import 'package:wintek/features/game/aviator/providers/user_provider.dart';
import 'package:wintek/features/game/aviator/widget/auto_play_widget.dart';
import 'package:wintek/features/game/crash/providers/crash_game_provider.dart';

class AutoPlayState {
  final AutoPlaySettings? settings;
  final int roundsPlayed;
  final double initialWallet;
  final double lastWinAmount;

  AutoPlayState({
    this.settings,
    this.roundsPlayed = 0,
    this.initialWallet = 0.0,
    this.lastWinAmount = 0.0,
  });

  AutoPlayState copyWith({
    AutoPlaySettings? settings,
    int? roundsPlayed,
    double? initialWallet,
    double? lastWinAmount,
  }) {
    return AutoPlayState(
      settings: settings ?? this.settings,
      roundsPlayed: roundsPlayed ?? this.roundsPlayed,
      initialWallet: initialWallet ?? this.initialWallet,
      lastWinAmount: lastWinAmount ?? this.lastWinAmount,
    );
  }
}

class CrashCustomBetButton extends ConsumerStatefulWidget {
  final int index;
  final TextEditingController amountController;
  final TextEditingController? switchController;
  final AutoPlayState? autoPlayState;
  final Function(int, double)? onAutoPlayUpdate;
  final VoidCallback? onAutoPlayStop;
  final bool Function(double, double)? shouldContinueAutoPlay;
  final ValueChanged<bool>? onManualBetPlaced;

  const CrashCustomBetButton({
    super.key,
    required this.index,
    required this.amountController,
    this.switchController,
    this.autoPlayState,
    this.onAutoPlayUpdate,
    this.onAutoPlayStop,
    this.shouldContinueAutoPlay,
    this.onManualBetPlaced,
  });

  @override
  ConsumerState<CrashCustomBetButton> createState() =>
      _CrashCustomBetButtonState();
}

class _CrashCustomBetButtonState extends ConsumerState<CrashCustomBetButton> {
  bool hasPlacedBet = false;
  bool hasAutoCashedOut = false;
  String? lastRoundId;
  double? lastMultiplier;
  bool _isPlacingBet = false; // Flag to prevent duplicate bet placement
  bool _betParticipatedInRound =
      false; // Tracks if we had a bet in the last round

  // Queued bet state when user taps during RUNNING
  bool _hasQueuedBet = false;
  String? _queuedAmountText;
  double? _queuedAutoCashoutValue;

  final secureStorageService = SecureStorageService();

  Future<String?> getUserId() async {
    final creds = await secureStorageService.readCredentials();
    return creds.userId;
  }

  void _evaluateAutoPlayAndMaybeBet(CrashRoundState? round) {
    if (widget.autoPlayState == null ||
        widget.autoPlayState!.settings == null ||
        widget.shouldContinueAutoPlay == null ||
        round == null ||
        round.state != 'PREPARE' ||
        hasPlacedBet ||
        _isPlacingBet) {
      return;
    }

    final user = ref.read(userProvider);
    user.maybeWhen(
      data: (userModel) {
        if (userModel == null) return;
        final currentWallet = userModel.data.wallet;
        final lastWinAmount = widget.autoPlayState!.lastWinAmount;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final shouldContinue = widget.shouldContinueAutoPlay!(
            currentWallet,
            lastWinAmount,
          );

          if (!shouldContinue) {
            widget.onAutoPlayStop?.call();
            return;
          }

          final latestRound = ref.read(crashRoundNotifierProvider);
          if (latestRound?.state != 'PREPARE') return;
          if (hasPlacedBet || _isPlacingBet) return;
          _placeBet(isAutoPlay: true);
        });
      },
      orElse: () {},
    );
  }

  Future<void> _placeBet({
    String? amountOverride,
    double? autoCashoutOverride,
    bool isAutoPlay = false,
  }) async {
    log(
      "🎲 _placeBet called - amountOverride: $amountOverride, autoCashoutOverride: $autoCashoutOverride",
    );
    // Prevent duplicate bet placement
    if (_isPlacingBet || hasPlacedBet) return;

    _isPlacingBet = true;

    try {
      final round = ref.watch(crashRoundNotifierProvider);
      final betService = ref.read(crashBetServiceProvider);
      final userId = await getUserId();

      if (userId == null ||
          round == null ||
          round.roundId == null ||
          round.seq == null) {
        return;
      }

      // Only place bet during PREPARE; queued bets will call this when the
      // next round is in PREPARE state.
      if (round.state != 'PREPARE') {
        log('⚠️ Skipping bet placement, invalid round state: ${round.state}');
        return;
      }

      // Determine stake / auto cashout source: queued override vs controllers
      late final String amountText;
      late final double? autoCashoutValue;

      if (amountOverride != null || autoCashoutOverride != null) {
        amountText = (amountOverride ?? '').trim();
        autoCashoutValue = autoCashoutOverride;
      } else {
        final controllerAmountText = widget.amountController.text.trim();
        amountText = controllerAmountText;
        if (isAutoPlay) {
          autoCashoutValue = widget.autoPlayState?.settings?.autoCashout;
        } else {
          autoCashoutValue = ref.read(crashAutoCashoutProvider)[widget.index];
        }
        log(
          "💰 Reading auto-cashout for bet index ${widget.index}: $autoCashoutValue",
        );
        log("💰 Full provider state: ${ref.read(crashAutoCashoutProvider)}");
      }

      if (amountText.isEmpty) {
        log('⚠️ Bet amount is empty');
        return;
      }

      final roundId = round.roundId;
      final seq = round.seq;

      final newBet = await betService.placeBet(
        CrashBetRequestModel(
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
            .read(crashBetResponseProvider.notifier)
            .setBetResponse(widget.index, newBet);
        ref.read(crashBetStateProvider.notifier).placeBet(widget.index);

        // Update wallet after placing bet
        final currentUser = ref.read(userProvider);
        currentUser.maybeWhen(
          data: (userModel) {
            if (userModel != null && newBet.stake != null) {
              final newWallet = userModel.data.wallet - newBet.stake!;
              ref.read(userProvider.notifier).updateWallet(newWallet);
            }
          },
          orElse: () {},
        );

        setState(() {
          hasPlacedBet = true;
          _betParticipatedInRound = true;
        });

        if (!isAutoPlay) {
          widget.onManualBetPlaced?.call(true);
        }

        log('✅ Bet placed successfully: ${newBet.stake}');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? 'Bet failed';
      log('❌ Error placing bet: $errorMsg');
      _customSnackBar(context, errorMsg);
    } catch (e) {
      log('❌ Error placing bet: $e');
      _customSnackBar(context, 'Something went wrong. Please try again.');
    } finally {
      _isPlacingBet = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final round = ref.watch(crashRoundNotifierProvider);
    final tick = ref.watch(crashTickProvider);
    ref.watch(crashGameProvider);

    // Reset hasPlacedBet if a new round starts
    if (round != null && round.roundId != lastRoundId) {
      final participatedInPreviousRound = _betParticipatedInRound;

      hasPlacedBet = false;
      hasAutoCashedOut = false;
      _betParticipatedInRound = false;
      lastMultiplier = null;
      lastRoundId = round.roundId;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onManualBetPlaced?.call(false);
      });

      // Clear the bet for the new round
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref
            .read(crashBetResponseProvider.notifier)
            .setBetResponse(widget.index, null);
      });

      // If we had a bet in the previous round and autoplay is active,
      // increment the round counter regardless of win/loss
      if (participatedInPreviousRound &&
          widget.autoPlayState != null &&
          widget.autoPlayState!.settings != null) {
        final nextRoundCount = (widget.autoPlayState?.roundsPlayed ?? 0) + 1;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onAutoPlayUpdate?.call(
            nextRoundCount,
            widget.autoPlayState?.lastWinAmount ?? 0.0,
          );
        });
      }

      // If user queued a bet while the previous round was RUNNING,
      // automatically place it at the start of the next PREPARE phase.
      if (_hasQueuedBet && round.state == 'PREPARE') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _placeBet(
            amountOverride: _queuedAmountText,
            autoCashoutOverride: _queuedAutoCashoutValue,
            isAutoPlay: false,
          );
          if (mounted) {
            setState(() {
              _hasQueuedBet = false;
              _queuedAmountText = null;
              _queuedAutoCashoutValue = null;
            });
          }
        });
      }
    }

    _evaluateAutoPlayAndMaybeBet(round);

    final bet = ref.watch(crashBetResponseProvider)[widget.index];

    // Handle waiting state between placing bet and running
    final isWaitingForRound = hasPlacedBet && round?.state == 'PREPARE';
    final isCashoutButton = hasPlacedBet && round?.state == 'RUNNING';

    // Auto Cashout logic
    if (isCashoutButton && bet != null && bet.autoCashout != null) {
      log("🎯 Auto cashout enabled: ${bet.autoCashout}x");
      tick.whenData((tickData) async {
        final multiplier =
            double.tryParse(tickData.multiplier.toString()) ?? 0.0;

        // Only trigger cashout once when crossing the threshold
        // Use > instead of >= to ensure server multiplier is past the target
        if (!hasAutoCashedOut &&
            multiplier > bet.autoCashout! &&
            (lastMultiplier == null || lastMultiplier! <= bet.autoCashout!)) {
          log(
            "🚀 Auto cashout condition met! Multiplier: $multiplier, Target: ${bet.autoCashout}",
          );
          lastMultiplier = multiplier;
          hasAutoCashedOut = true;

          int retryCount = 0;
          const maxRetries = 10;

          while (retryCount < maxRetries) {
            try {
              // Longer delay on first attempt to ensure server catches up
              // Shorter delays on retries
              final delayMs = retryCount == 0 ? 200 : 100;
              await Future.delayed(Duration(milliseconds: delayMs));

              final cashoutService = ref.read(crashCashoutServiceProvider);
              final response = await cashoutService.cashout(
                id: bet.id!,
                cashOutAt: bet.autoCashout!,
              );
              final cashoutAt = response.cashoutAt;

              if (cashoutAt != null) {
                log("✅ Auto Cashout triggered at $cashoutAt X");

                // Update wallet
                final currentUser = ref.read(userProvider);
                currentUser.maybeWhen(
                  data: (userModel) {
                    if (userModel != null) {
                      final winAmount = cashoutAt * bet.stake!;
                      final newWallet = userModel.data.wallet + winAmount;
                      ref.read(userProvider.notifier).updateWallet(newWallet);

                      // Note: Round counting is now handled at round start,
                      // not here, to ensure every round is counted regardless of outcome
                    }
                  },
                  orElse: () {},
                );

                if (mounted) {
                  setState(() {
                    hasPlacedBet = false;
                  });
                  widget.onManualBetPlaced?.call(false);
                }

                // Show flushbar
                _successFlushbar(
                  context: context,
                  message1: "Auto Cashout at!\n",
                  multiplier: '$cashoutAt X',
                  message2: 'Win INR\n',
                  winAmount: (cashoutAt * bet.stake!).toStringAsFixed(2),
                );
                break; // Success, exit loop
              }
            } catch (e) {
              retryCount++;
              if (retryCount >= maxRetries) {
                log("❌ Auto Cashout failed after $maxRetries attempts: $e");
                hasAutoCashedOut = false; // Reset only after all retries fail
              } else if (retryCount == 1) {
                // Only log the first retry to avoid spamming
                log("⚠️ Auto Cashout syncing with server...");
              }
            }
          }
        }
        lastMultiplier = multiplier;
      });
    }

    // Auto Cashout logic - implement later
    // if (isCashoutButton && bet != null && bet.autoCashout != null) {
    //   tick.whenData((tickData) async {

    //     ...
    //   });
    // }

    final isQueuedBet =
        !hasPlacedBet && _hasQueuedBet && round?.state == 'RUNNING';

    final buttonText = !hasPlacedBet
        ? (isQueuedBet ? "WAITING" : "BET")
        : isCashoutButton
        ? "CASHOUT"
        : isWaitingForRound
        ? "WAITING"
        : "BET";

    final enabled = !hasPlacedBet || isCashoutButton;

    return SizedBox(
      height: 200,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (!hasPlacedBet) {
              if (_hasQueuedBet) {
                // queued bet uses the same color as CASHOUT state
                return AppColors.crashTwentyFourthColor;
              }
              return AppColors.crashFifteenthColor; // initial Place Bet
            } else if (hasPlacedBet && round?.state == 'RUNNING') {
              return AppColors.crashFourteenthColor; // CASHOUT
            } else if (round?.state == 'CRASHED') {
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

        onPressed: enabled
            ? () async {
                // Place Bet or cancel queued bet
                if (!hasPlacedBet && round != null) {
                  if (_hasQueuedBet && round.state == 'RUNNING') {
                    // Cancel the queued bet
                    setState(() {
                      _hasQueuedBet = false;
                      _queuedAmountText = null;
                      _queuedAutoCashoutValue = null;
                    });
                    _customSnackBar(context, 'Pending bet cancelled.');
                    return;
                  }

                  if (round.state == 'RUNNING') {
                    // Queue bet for the next round instead of rejecting
                    final amountText = widget.amountController.text.trim();
                    // Read auto-cashout from the provider, not from a switch controller
                    final autoCashoutValue = ref.read(
                      crashAutoCashoutProvider,
                    )[widget.index];

                    if (amountText.isEmpty) {
                      _customSnackBar(context, 'Please enter an amount to bet');
                      return;
                    }

                    setState(() {
                      _hasQueuedBet = true;
                      _queuedAmountText = amountText;
                      _queuedAutoCashoutValue = autoCashoutValue;
                    });

                    _customSnackBar(
                      context,
                      'Your bet has been added to the next round.',
                    );
                  } else {
                    await _placeBet(isAutoPlay: false);
                  }
                }
                // Cashout
                else if (isCashoutButton &&
                    bet != null &&
                    bet.id != null &&
                    bet.stake != null) {
                  final cashoutService = ref.read(crashCashoutServiceProvider);
                  final multiplier = tick.maybeWhen(
                    data: (tickData) {
                      final value = tickData.multiplier;
                      if (value is num) {
                        return double.tryParse(value.toString()) ?? 0.0;
                      }
                      if (value is String) return double.tryParse(value) ?? 0.0;
                      return 0.0;
                    },
                    orElse: () => 0.0,
                  );
                  final roundedMultiplier = (multiplier * 100).round() / 100.0;

                  try {
                    log(
                      "📤 Cashout request: id=${bet.id}, cashOutAt=$roundedMultiplier",
                    );

                    // Small delay to ensure multiplier is stable
                    //      await Future.delayed(const Duration(milliseconds: 50));
                    final response = await cashoutService.cashout(
                      id: bet.id!,
                      cashOutAt: roundedMultiplier,
                    );
                    if (mounted) {
                      setState(() {
                        hasPlacedBet = false;
                      });
                      widget.onManualBetPlaced?.call(false);
                    }
                    final cashoutAt = response.cashoutAt;
                    if (cashoutAt == null) return;
                    log('✅ CashoutAt: $cashoutAt X');

                    // Update wallet after cashout
                    final currentUser = ref.read(userProvider);
                    currentUser.maybeWhen(
                      data: (userModel) {
                        if (userModel != null) {
                          final winAmount = cashoutAt * bet.stake!;
                          final newWallet = userModel.data.wallet + winAmount;
                          ref
                              .read(userProvider.notifier)
                              .updateWallet(newWallet);
                        }
                      },
                      orElse: () {},
                    );

                    // ✅ show Flushbar only if success
                    _successFlushbar(
                      context: context,
                      message1: "You Have Cashed\nOut!",
                      multiplier: '\n$cashoutAt X',
                      message2: "Win INR\n",
                      winAmount: (cashoutAt * bet.stake!).toStringAsFixed(2),
                    );
                  } catch (e, st) {
                    log("❌ Cashout error: $e\n$st");
                  }
                }
              }
            : null,
        child: isQueuedBet
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.crashHeadlineSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Wait for next round',
                    style: Theme.of(context).textTheme.crashbodySmallThird,
                  ),
                ],
              )
            : Text(
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

  // Custom SnackBar
  void _customSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.crashTwentyFourthColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
