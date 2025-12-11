import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to manage music on/off state for Crash game
final crashMusicProvider = StateNotifierProvider<CrashMusicNotifier, bool>(
  (ref) => CrashMusicNotifier(),
);

class CrashMusicNotifier extends StateNotifier<bool> {
  CrashMusicNotifier() : super(true); // Default to ON

  void toggle() {
    state = !state;
  }

  void setMusic(bool value) {
    state = value;
  }
}

// Provider to manage start sound on/off state for Crash game
final crashStartSoundProvider =
    StateNotifierProvider<CrashStartSoundNotifier, bool>(
      (ref) => CrashStartSoundNotifier(),
    );

class CrashStartSoundNotifier extends StateNotifier<bool> {
  CrashStartSoundNotifier() : super(true); // Default to ON

  void toggle() {
    state = !state;
  }

  void setStartSound(bool value) {
    state = value;
  }
}
