// ignore_for_file: library_prefixes

import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wintek/core/constants/socket_constants/socket_constants.dart';
import 'package:wintek/features/game/aviator/domain/constants/aviator_socket_constants.dart';
import 'package:wintek/features/game/aviator/domain/models/aviator_round.dart';

typedef RoundCallback = void Function(AviatorRound round);

class AviatorSocketService {
  IO.Socket? _socket;

  void connect({
    String? token,
    RoundCallback? onRoundState,
    RoundCallback? onRoundTick,
    RoundCallback? onRoundCrash,
  }) {
    _socket = IO.io(
      SocketConstants.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({
            if (token != null) 'Authorization': 'Bearer $token',
          })
          .build(),
    );
    _socket!.connect();

    _socket!.onConnect((_) => log('socket connected'));
    _socket!.onDisconnect((_) => log('Socket disconnected'));

    //event for round
    _socket!.on(AviatorSocketConstants.roundState, (data) {
      // log('Round state: $data');
      if (onRoundState != null) {
        onRoundState(AviatorRound.fromJson(data));
      }
    });

    //tick
    _socket!.on(AviatorSocketConstants.roundTick, (data) {
      // log('Round tick: $data');
      if (onRoundTick != null) {
        onRoundTick(AviatorRound.fromJson(data));
      }
    });

    //Crash at
    _socket!.on(AviatorSocketConstants.roundCrashAt, (data) {
      // log('Round crash at: $data');
      if (onRoundCrash != null) {
        onRoundCrash(AviatorRound.fromJson(data));
      }
    });

    _socket!.on(AviatorSocketConstants.betResult, (data) {
      // log('Bet result: $data');
    });
  }

  void emit(String event, dynamic data) {
    _socket!.emit(event, data);
  }

  void disConnect() {
    _socket?.disconnect();
  }
}
