// waiting_provider.dart
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/aviator/providers/aviator_round_provider.dart';
import 'package:wintek/features/game/aviator/domain/models/aviator_round.dart';

/// Tracks "waiting for next round" per bet index: Map<betIndex, bool>
final waitingForNextRoundProvider =
    StateNotifierProvider<WaitingNotifier, Map<int, bool>>((ref) {
      return WaitingNotifier(ref);
    });

class WaitingNotifier extends StateNotifier<Map<int, bool>> {
  final Ref ref;
  WaitingNotifier(this.ref) : super({}) {
    // Listen to the round provider and clear waiting flags when appropriate.
    ref.listen<RoundState?>(aviatorRoundNotifierProvider, (previous, next) {
      if (next == null) return;

      // If round id changed -> clear all waiting flags (new round started)
      if (previous?.roundId != null &&
          next.roundId != null &&
          previous!.roundId != next.roundId) {
        log('[WaitingNotifier] New round detected — clearing waiting flags');
        state = {};
        return;
      }

      // If round returned to PREPARE (betting window reopened), clear waiting flags
      if (next.state == 'PREPARE') {
        log('[WaitingNotifier] Round ENTERED PREPARE — clearing waiting flags');
        state = {};
        return;
      }

      // You can add other rules here if you want flags cleared on CASHOUT/crash, etc.
    });
  }

  void setWaiting(int index) {
    log('[WaitingNotifier] set waiting for index: $index');
    state = {...state, index: true};
  }

  void clearWaiting(int index) {
    log('[WaitingNotifier] clear waiting for index: $index');
    final copy = Map<int, bool>.from(state);
    copy[index] = false;
    state = copy;
  }

  void clearAll() {
    log('[WaitingNotifier] clear ALL waiting flags');
    state = {};
  }
}
