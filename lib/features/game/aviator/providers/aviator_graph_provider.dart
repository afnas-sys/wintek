// import 'dart:async';
// import 'dart:developer';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../service/aviator_api_service.dart';
// import '../service/aviator_socket_service.dart';
// import '../domain/models/aviator_round.dart';

// class AviatorGraphNotifier extends StateNotifier<List<FlSpot>> {
//   final AviatorApiService _api;
//   final AviatorSocketService _socket;

//   // Stream to broadcast the current round state
//   final StreamController<String> _roundStateController =
//       StreamController.broadcast();
//   Stream<String> get roundStateStream => _roundStateController.stream;

//   double startTime = DateTime.now().millisecondsSinceEpoch.toDouble();
//   double _x = 0;

//   // Current round info
//   String currentRoundId = '';
//   int currentSeq = 0;
//   double currentMultiplier = 0;
//   String currentState = '';

//   late StreamSubscription<AviatorRound> _roundSub;
//   late StreamSubscription<AviatorRound> _tickSub;
//   late StreamSubscription<AviatorRound> _crashSub;

//   static const int maxPoints = 500;

//   AviatorGraphNotifier(this._api, this._socket) : super([]) {
//     _init();
//   }

//   Future<void> _init() async {
//     // Load initial round from API
//     try {
//       final round = await _api.getCurrentRound();
//       if (round != null) {
//         _updateCurrent(round);
//         _roundStateController.add(round.state);
//       }
//     } catch (e) {
//       log('API Error: $e');
//     }

//     // Connect socket
//     _socket.connect();

//     // Listen to socket events
//     _roundSub = _socket.roundStateStream.listen((round) {
//       if (round.state.toUpperCase() == "PREPARE") {
//         startTime = DateTime.now().millisecondsSinceEpoch.toDouble();
//         _x = 0;
//         state = [];
//       }
//       _updateCurrent(round);
//       _roundStateController.add(round.state);
//       log('🔄 Round State: ${round.state}');
//     });

//     _tickSub = _socket.roundTickStream.listen((round) {
//       if (round.multiplier != null) {
//         _x += 0.1;
//         state = [
//           ...state,
//           FlSpot(_x, round.multiplier!),
//         ].takeLast(maxPoints).toList();
//         _updateCurrent(round);
//         _roundStateController.add(round.state);
//       }
//     });

//     _crashSub = _socket.roundCrashStream.listen((round) {
//       if (round.multiplier != null) {
//         _x += 0.1;
//         state = [
//           ...state,
//           FlSpot(_x, round.multiplier!),
//         ].takeLast(maxPoints).toList();
//         _updateCurrent(round);
//         _roundStateController.add(round.state);
//         log('💥 Crash multiplier: ${round.multiplier}');
//       }
//     });
//   }

//   void _updateCurrent(AviatorRound round) {
//     currentRoundId = round.roundId;
//     currentSeq = round.seq;
//     currentMultiplier = round.multiplier ?? 0;
//     currentState = round.state;
//   }

//   @override
//   void dispose() {
//     _roundSub.cancel();
//     _tickSub.cancel();
//     _crashSub.cancel();
//     _socket.disConnect();
//     _roundStateController.close();
//     super.dispose();
//   }
// }

// // Helper extension
// extension TakeLast<T> on Iterable<T> {
//   Iterable<T> takeLast(int n) => skip(length - n < 0 ? 0 : length - n);
// }

// // Provider
// final aviatorGraphProvider =
//     StateNotifierProvider<AviatorGraphNotifier, List<FlSpot>>((ref) {
//       final api = AviatorApiService();
//       final socket = AviatorSocketService();
//       return AviatorGraphNotifier(api, socket);
//     });
