import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/aviator/domain/models/aviator_round.dart';
import 'package:wintek/features/game/aviator/service/aviator_api_service.dart';
import 'package:wintek/features/game/aviator/service/aviator_socket_service.dart';

final aviatorApiProvider = Provider((ref) => AviatorApiService());
final aviatorSocketProvider = Provider((ref) => AviatorSocketService());

final aviatorProvider = StateNotifierProvider<AviatorNotifier, AviatorRound?>((
  ref,
) {
  final api = ref.read(aviatorApiProvider);
  final socket = ref.read(aviatorSocketProvider);
  final notifier = AviatorNotifier(api, socket);

  ref.onDispose(() => notifier.dispose());

  return notifier;
});

class AviatorNotifier extends StateNotifier<AviatorRound?> {
  final AviatorApiService _api;
  final AviatorSocketService _socket;

  AviatorNotifier(this._api, this._socket) : super(null) {
    _init();
  }

  Future<void> _init() async {
    //! 1) Load initial round from API
    final round = await _api.getCurrentRound();
    if (round != null) state = round;

    //! 2) Start listening to socket updates
    _socket.connect(
      onRoundState: _updateRound,
      onRoundTick: _updateRound,
      onRoundCrash: _updateRound,
    );
  }

  void _updateRound(AviatorRound newRound) {
    // merge updates with current state instead of overwrite
    state = state?.copyWithFrom(newRound) ?? newRound;
  }

  @override
  void dispose() {
    _socket.disConnect();
    super.dispose();
  }
}

class AviatorGraphNotifier extends StateNotifier<List<FlSpot>> {
  final AviatorApiService _api;
  final AviatorSocketService _socket;
  double _x = 0;

  // Store latest roundId & seq for outside usage
  String? currentRoundId;
  int? currentSeq;
  double? currentMultiplier;

  AviatorGraphNotifier(this._api, this._socket) : super([]) {
    _init();
  }

  Future<void> _init() async {
    final round = await _api.getCurrentRound();
    if (round != null) {
      currentRoundId = round.id;
      currentSeq = round.seq;
      currentMultiplier = round.multiplier;
    }

    _socket.connect(
      onRoundState: (round) {
        // reset graph when new round starts
        _x = 0;
        state = [];
        currentRoundId = round.id;
        currentSeq = round.seq;
        currentMultiplier = round.multiplier;

        log("🔄 New Round -> roundId: $currentRoundId, seq: $currentSeq");
      },
      onRoundTick: (round) {
        // add multiplier point each tick
        _x += 0.1;
        state = [...state, FlSpot(_x, round.multiplier)];

        currentRoundId = round.id;
        currentSeq = round.seq;
        currentMultiplier = round.multiplier;

        //  log("📈 Tick update -> roundId: $currentRoundId, seq: $currentSeq");
      },
      onRoundCrash: (round) {
        _x += 0.1;
        state = [...state, FlSpot(_x, round.multiplier)];

        currentRoundId = round.id;
        currentSeq = round.seq;
        currentMultiplier = round.multiplier;

        //  log("💥 Crash -> roundId: $currentRoundId, seq: $currentSeq");
      },
    );
  }

  @override
  void dispose() {
    _socket.disConnect();
    super.dispose();
  }
}

final aviatorGraphProvider =
    StateNotifierProvider<AviatorGraphNotifier, List<FlSpot>>((ref) {
      final api = AviatorApiService();
      final socket = AviatorSocketService();
      return AviatorGraphNotifier(api, socket);
    });
