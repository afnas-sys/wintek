import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/event_model.dart';
import 'package:wintek/features/game/card_jackpot/providers/card_game_notifier.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, Duration>(
  (ref) => TimerNotifier(ref),
);

class TimerNotifier extends StateNotifier<Duration> {
  final Ref ref;
  TimerNotifier(this.ref) : super(Duration.zero);

  Timer? _timer;
  ProviderSubscription? _roundListener;

  void start() {
    if (_roundListener != null) return; // prevent double listeners

    _roundListener = ref.listen<RoundEvent?>(cardRoundNotifierProvider, (
      previous,
      next,
    ) {
      if (next?.msRemaining != null) {
        final ms = next!.msRemaining;
        if (ms != null) {
          state = Duration(milliseconds: ms);
        }

        _timer?.cancel();
        _startCountdown();
      }
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.inSeconds > 0) {
        state = Duration(seconds: state.inSeconds - 1);
      } else {
        _timer?.cancel();
        // round finished -> do any post-round actions here
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _roundListener?.close();
    super.dispose();
  }
}
