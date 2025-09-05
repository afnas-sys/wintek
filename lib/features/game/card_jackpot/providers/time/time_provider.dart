import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/providers/game_round/game_round_provider.dart';

const roundDuration = Duration(minutes: 3);

final timerProvider = StateNotifierProvider<TimerNotifier, Duration>(
  (ref) => TimerNotifier(ref),
);

class TimerNotifier extends StateNotifier<Duration> {
  final Ref ref;
  TimerNotifier(this.ref) : super(roundDuration);

  Timer? _timer;

  void start() {
    if (_timer != null && _timer!.isActive) return;

    ref.read(betProvider.notifier).createNewRound();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.inSeconds > 0) {
        state = Duration(seconds: state.inSeconds - 1);
      } else {
        state = roundDuration;
        ref.read(betProvider.notifier).updateStatus();
        ref.read(betProvider.notifier).createNewRound();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
