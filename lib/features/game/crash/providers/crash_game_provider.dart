import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GameState { prepare, running, crashed }

class CrashGameState {
  final GameState state;
  final double currentMultiplier;
  final double crashMultiplier;
  final int prepareSecondsLeft;

  CrashGameState({
    required this.state,
    required this.currentMultiplier,
    required this.crashMultiplier,
    required this.prepareSecondsLeft,
  });

  CrashGameState copyWith({
    GameState? state,
    double? currentMultiplier,
    double? crashMultiplier,
    int? prepareSecondsLeft,
  }) {
    return CrashGameState(
      state: state ?? this.state,
      currentMultiplier: currentMultiplier ?? this.currentMultiplier,
      crashMultiplier: crashMultiplier ?? this.crashMultiplier,
      prepareSecondsLeft: prepareSecondsLeft ?? this.prepareSecondsLeft,
    );
  }
}

class CrashGameNotifier extends StateNotifier<CrashGameState> {
  Timer? _gameTimer;
  Timer? _prepareTimer;

  CrashGameNotifier()
    : super(
        CrashGameState(
          state: GameState.prepare,
          currentMultiplier: 1.0,
          crashMultiplier: 0.0,
          prepareSecondsLeft: 10,
        ),
      ) {
    _startPrepareCountdown();
  }

  void _startPrepareCountdown() {
    state = state.copyWith(
      state: GameState.prepare,
      prepareSecondsLeft: 10,
      currentMultiplier: 1.0,
    );

    _prepareTimer?.cancel();
    _prepareTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.prepareSecondsLeft <= 1) {
        timer.cancel();
        _startGame();
      } else {
        state = state.copyWith(
          prepareSecondsLeft: state.prepareSecondsLeft - 1,
        );
      }
    });
  }

  void _startGame() {
    // Generate random crash multiplier between 1.1 and 10.0
    final crashMultiplier = 1.1 + Random().nextDouble() * 15.9;

    state = state.copyWith(
      state: GameState.running,
      currentMultiplier: 1.0,
      crashMultiplier: crashMultiplier,
    );

    // Start multiplier increment
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final newMultiplier = state.currentMultiplier + 0.01;
      if (newMultiplier >= state.crashMultiplier) {
        _crashGame();
      } else {
        state = state.copyWith(currentMultiplier: newMultiplier);
      }
    });
  }

  void _crashGame() {
    _gameTimer?.cancel();
    state = state.copyWith(state: GameState.crashed);
    // Auto restart after crash
    Future.delayed(const Duration(seconds: 3), () {
      _startPrepareCountdown();
    });
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _prepareTimer?.cancel();
    super.dispose();
  }
}

final crashGameProvider =
    StateNotifierProvider<CrashGameNotifier, CrashGameState>(
      (ref) => CrashGameNotifier(),
    );
