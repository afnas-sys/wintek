import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/aviator/domain/models/aviator_round.dart';
import 'package:wintek/features/game/aviator/service/aviator_socket_service.dart';

final aviatorRoundProvider = Provider<AviatorSocketService>((ref) {
  final service = AviatorSocketService();
  service.connect();
  ref.onDispose(() => service.disConnect());
  return service;
});
// //! Round State Provider
final aviatorStateProvider = StreamProvider<RoundState>((ref) {
  final service = ref.watch(aviatorRoundProvider);
  return service.stateStream;
});

//! Round Tick Provider
final aviatorTickProvider = StreamProvider<Tick>((ref) {
  final servise = ref.watch(aviatorRoundProvider);
  return servise.tickStream;
});
//! Crash provider

final aviatorCrashProvider = StreamProvider<Crash>((ref) {
  final service = ref.watch(aviatorRoundProvider);
  return service.crashStream;
});

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
    StateNotifierProvider<AviatorRoundNotifier, RoundState?>((ref) {
      final service = ref.watch(aviatorRoundProvider);
      return AviatorRoundNotifier(service);
    });
