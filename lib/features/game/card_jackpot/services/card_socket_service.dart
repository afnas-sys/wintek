import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wintek/core/constants/socket_constants/socket_constants.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/bet_result_event.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/round_end_event.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/round_new_event.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/round_state_event.dart';
import 'package:wintek/features/game/card_jackpot/providers/card_game_notifier.dart';

class CardSocketService {
  late IO.Socket socket;
  final CardRoundNotifier notifier;
  final secureStorageService = SecureStorageService();
  CardSocketService(this.notifier);

  void connect() async {
    final secureStorage = await secureStorageService.readCredentials();
    final token = secureStorage.token;
    log('TOKEN: $token');
    socket = IO.io(
      SocketConstants.cardSocketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    socket.onConnect((_) => log("✅ Card Jackpot Socket connected"));

    // round:new
    socket.on("round:new", (data) {
      final event = RoundNewEvent.fromJson(data);
      notifier.updateRoundNew(event);
    });

    // round:state
    socket.on("round:state", (data) {
      final event = RoundStateEvent.fromJson(data);
      notifier.updateRoundState(event);
    });

    // bet:result
    socket.on("bet:result", (data) {
      final event = BetResultEvent.fromJson(data);
      notifier.updateBetResult(event);
    });

    // round:end
    socket.on("round:end", (data) {
      final event = RoundEndEvent.fromJson(data);
      notifier.updateRoundEnd(event);
    });

    socket.onDisconnect((_) => log("❌ Card Jackpot Socket disconnected"));
  }

  void placeBet(Map<String, dynamic> bet) {
    socket.emit("place_bet", bet);
    // notifier.setBetting(true);
  }

  void disconnect() {
    socket.disconnect();
  }
}
