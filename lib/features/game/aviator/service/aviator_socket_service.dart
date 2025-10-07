import 'dart:async';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wintek/core/constants/socket_constants/socket_constants.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/aviator/domain/constants/aviator_socket_constants.dart';
import 'package:wintek/features/game/aviator/domain/models/aviator_round.dart';

class AviatorSocketService {
  final _stateController = StreamController<RoundState>.broadcast();
  final _tickController = StreamController<Tick>.broadcast();
  final _crashController = StreamController<Crash>.broadcast();
  final secureStorageService = SecureStorageService();

  Stream<RoundState> get stateStream => _stateController.stream;
  Stream<Tick> get tickStream => _tickController.stream;
  Stream<Crash> get crashStream => _crashController.stream;
  IO.Socket? socket;

  void connect() async {
    if (socket != null && socket!.connected) return;
    final storageService = await secureStorageService.readCredentials();
    final token = storageService.token;
    log('👉 Token: $token');
    socket = IO.io(
      SocketConstants.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) => log('Socket connected'));
    socket!.onDisconnect((_) => log('Socket disconnected'));

    //! state
    socket!.on(AviatorSocketConstants.roundState, (data) {
      // log('Round State: $data');
      try {
        final state = RoundState.fromJson(data);
        _stateController.add(state);
        //    log('😎😎😎 Round State Success: ${state.toJson()}');
      } catch (e) {
        //log('😴😴😴Error: $e');
      }
    });

    //! Tick
    socket!.on(AviatorSocketConstants.roundTick, (data) {
      //log('Round Tick: $data');
      try {
        final tick = Tick.fromJson(data);
        _tickController.add(tick);
        //   log('😎😎😎 Round Tick Success: ${tick.toJson()}');
      } catch (e) {
        //   log('😴😴😴Error: $e');
      }
    });

    //! Crash
    socket!.on(AviatorSocketConstants.roundCrashAt, (data) {
      // log('Round Crash: $data');
      try {
        final crash = Crash.fromJson(data);
        _crashController.add(crash);
        // log('😎😎😎 Round Crash Success: ${crash.toJson()}');
      } catch (e) {
        //   log('😴😴😴Error: $e');
      }
    });
  }

  void disconnect() {
    socket?.disconnect();
    socket?.destroy();
    _stateController.close();
    _tickController.close();
    log('Socket disconnected');
  }
}
