import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CrashAutoCashoutNotifier extends StateNotifier<Map<int, double?>> {
  CrashAutoCashoutNotifier() : super({});

  void setAutoCashout(int index, double? value) {
    log("📊 Setting auto-cashout for index $index: $value");
    final newState = Map<int, double?>.from(state);
    newState[index] = value;
    state = newState;
    log("📊 Current state: $state");
  }

  double? getAutoCashout(int index) {
    final value = state[index];
    log("📊 Getting auto-cashout for index $index: $value");
    return value;
  }
}

final crashAutoCashoutProvider =
    StateNotifierProvider<CrashAutoCashoutNotifier, Map<int, double?>>(
      (ref) => CrashAutoCashoutNotifier(),
    );
