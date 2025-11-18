import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/aviator/domain/models/all_bets_model.dart';
import 'package:wintek/features/game/aviator/domain/models/aviator_round.dart';
import 'package:wintek/features/game/aviator/service/aviator_socket_service.dart';

final aviatorRoundProvider = Provider.autoDispose<AviatorSocketService>((ref) {
  final service = AviatorSocketService();
  service.connect();
  ref.onDispose(() => service.disconnect());
  return service;
});
// //! Round State Provider
final aviatorStateProvider = StreamProvider.autoDispose<RoundState>((ref) {
  final service = ref.watch(aviatorRoundProvider);
  return service.stateStream;
});

//! Round Tick Provider
final aviatorTickProvider = StreamProvider.autoDispose<Tick>((ref) {
  final service = ref.watch(aviatorRoundProvider);
  return service.tickStream;
});
//! Crash provider

// final aviatorCrashProvider = StreamProvider<Crash>((ref) {
//   final service = ref.watch(aviatorRoundProvider);
//   return service.crashStream;
// });

//! --- State Notifier ---

class AviatorRoundNotifier extends StateNotifier<RoundState?> {
  final AviatorSocketService _service;
  late final StreamSubscription _sub;

  AviatorRoundNotifier(this._service) : super(null) {
    // Listen to the socket stream and update state
    _sub = _service.stateStream.listen((round) {
      state = round;
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final aviatorRoundNotifierProvider =
    StateNotifierProvider.autoDispose<AviatorRoundNotifier, RoundState?>((ref) {
      final service = ref.watch(aviatorRoundProvider);
      return AviatorRoundNotifier(service);
    });

//! --- Crash Notifier ---
class AviatorCrashNotifier extends StateNotifier<Crash?> {
  final AviatorSocketService _service;
  late final StreamSubscription _sub;

  AviatorCrashNotifier(this._service) : super(null) {
    _sub = _service.crashStream.listen((crash) {
      state = crash;
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final aviatorCrashNotifierProvider =
    StateNotifierProvider.autoDispose<AviatorCrashNotifier, Crash?>((ref) {
      final service = ref.watch(aviatorRoundProvider);
      return AviatorCrashNotifier(service);
    });

//! Bets Notifier
class AviatorBetsNotifier extends StateNotifier<AllBetsModel?> {
  final AviatorSocketService _service;
  late final StreamSubscription _sub;

  AviatorBetsNotifier(this._service) : super(null) {
    _sub = _service.betsStream.listen((bets) {
      state = bets;
    });
  }
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final aviatorBetsNotifierProvider =
    StateNotifierProvider.autoDispose<AviatorBetsNotifier, AllBetsModel?>((
      ref,
    ) {
      final service = ref.watch(aviatorRoundProvider);
      return AviatorBetsNotifier(service);
    });
