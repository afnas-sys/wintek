import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/aviator/domain/models/aviator_round.dart';
import 'package:wintek/features/game/crash/domain/models/crash_all_bets_model.dart';
import 'package:wintek/features/game/crash/service/crash_socket_service.dart';

final crashRoundProvider = Provider.autoDispose<CrashSocketService>((ref) {
  final service = CrashSocketService();
  service.connect();
  ref.onDispose(() => service.disconnect());
  return service;
});
// //! Round State Provider
final crashStateProvider = StreamProvider.autoDispose<RoundState>((ref) {
  final service = ref.watch(crashRoundProvider);
  return service.stateStream;
});

//! Round Tick Provider
final crashTickProvider = StreamProvider.autoDispose<Tick>((ref) {
  final service = ref.watch(crashRoundProvider);
  return service.tickStream;
});
//! Crash provider

// final crashCrashProvider = StreamProvider<Crash>((ref) {
//   final service = ref.watch(crashRoundProvider);
//   return service.crashStream;
// });

//! --- State Notifier ---

class CrashRoundNotifier extends StateNotifier<RoundState?> {
  final CrashSocketService _service;
  late final StreamSubscription _sub;

  CrashRoundNotifier(this._service) : super(null) {
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

final crashRoundNotifierProvider =
    StateNotifierProvider.autoDispose<CrashRoundNotifier, RoundState?>((ref) {
      final service = ref.watch(crashRoundProvider);
      return CrashRoundNotifier(service);
    });

//! --- Crash Notifier ---
class CrashCrashNotifier extends StateNotifier<Crash?> {
  final CrashSocketService _service;
  late final StreamSubscription _sub;

  CrashCrashNotifier(this._service) : super(null) {
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

final crashCrashNotifierProvider =
    StateNotifierProvider.autoDispose<CrashCrashNotifier, Crash?>((ref) {
      final service = ref.watch(crashRoundProvider);
      return CrashCrashNotifier(service);
    });

//! Bets Notifier
class CrashBetsNotifier extends StateNotifier<CrashAllBetsModel?> {
  final CrashSocketService _service;
  late final StreamSubscription _sub;
  bool _isDisposed = false;

  CrashBetsNotifier(this._service) : super(null) {
    _sub = _service.betsStream.listen((bets) {
      if (!_isDisposed) {
        state = bets;
      }
    });
  }
  @override
  void dispose() {
    _isDisposed = true;
    _sub.cancel();
    super.dispose();
  }
}

final crashBetsNotifierProvider =
    StateNotifierProvider.autoDispose<CrashBetsNotifier, CrashAllBetsModel?>((
      ref,
    ) {
      final service = ref.watch(crashRoundProvider);
      return CrashBetsNotifier(service);
    });

//! Bet Result Notifier
class CrashBetResultNotifier extends StateNotifier<CrashAllBetsModel?> {
  final CrashSocketService _service;
  late final StreamSubscription _sub;
  bool _isDisposed = false;

  CrashBetResultNotifier(this._service) : super(null) {
    _sub = _service.betResultStream.listen((betResult) {
      if (!_isDisposed) {
        state = betResult;
      }
    });
  }
  @override
  void dispose() {
    _isDisposed = true;
    _sub.cancel();
    super.dispose();
  }
}

final crashBetResultNotifierProvider =
    StateNotifierProvider.autoDispose<
      CrashBetResultNotifier,
      CrashAllBetsModel?
    >((ref) {
      final service = ref.watch(crashRoundProvider);
      return CrashBetResultNotifier(service);
    });
