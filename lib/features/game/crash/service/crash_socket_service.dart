import 'dart:async';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wintek/core/constants/socket_constants/socket_constants.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/crash/domain/constants/crash_socket_constants.dart';
import 'package:wintek/features/game/crash/domain/models/crash_all_bets_model.dart';
import 'package:wintek/features/game/crash/domain/models/crash_round_model.dart';

class CrashSocketService {
  final _stateController = StreamController<CrashRoundState>.broadcast();
  final _tickController = StreamController<CrashTick>.broadcast();
  final _crashController = StreamController<CrashRoundCrash>.broadcast();
  final _betsController = StreamController<CrashAllBetsModel>.broadcast();
  final _betResultController = StreamController<CrashAllBetsModel>.broadcast();
  final _disconnectController = StreamController<void>.broadcast();
  final secureStorageService = SecureStorageService();

  Stream<CrashRoundState> get stateStream => _stateController.stream;
  Stream<CrashTick> get tickStream => _tickController.stream;
  Stream<CrashRoundCrash> get crashStream => _crashController.stream;
  Stream<CrashAllBetsModel> get betsStream => _betsController.stream;
  Stream<CrashAllBetsModel> get betResultStream => _betResultController.stream;
  Stream<void> get disconnectStream => _disconnectController.stream;
  IO.Socket? socket;

  void connect() async {
    if (socket != null && socket!.connected) return;
    final storageService = await secureStorageService.readCredentials();
    final token = storageService.token;
    log('👉 Token: $token');
    socket = IO.io(
      SocketConstants.crashSocketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) => log('Socket connected'));
    socket!.onDisconnect((_) {
      log('Socket disconnected');
      _disconnectController.add(null);
    });

    //! state
    socket!.on(CrashSocketConstants.roundState, (data) {
      // log('Round State: $data');
      try {
        final state = CrashRoundState.fromJson(data);
        _stateController.add(state);
        //    log('😎😎😎 Round State Success: ${state.toJson()}');
      } catch (e) {
        //log('😴😴😴Error: $e');
      }
    });

    //! Tick
    socket!.on(CrashSocketConstants.roundTick, (data) {
      //log('Round Tick: $data');
      try {
        final tick = CrashTick.fromJson(data);
        _tickController.add(tick);
        //   log('😎😎😎 Round Tick Success: ${tick.toJson()}');
      } catch (e) {
        //   log('😴😴😴Error: $e');
      }
    });

    //! Crash
    socket!.on(CrashSocketConstants.roundCrashAt, (data) {
      // log('Round Crash: $data');
      try {
        final crash = CrashRoundCrash.fromJson(data);
        _crashController.add(crash);
        // log('😎😎😎 Round Crash Success: ${crash.toJson()}');
      } catch (e) {
        //   log('😴😴😴Error: $e');
      }
    });

    //! Bets data
    socket!.on(CrashSocketConstants.roundBetsData, (data) {
      try {
        final bets = CrashAllBetsModel.fromJson(data);
        _betsController.add(bets);
      } catch (e) {
        log('😴😴😴Error: $e');
      }
    });

    //! Bet result
    socket!.on(CrashSocketConstants.betResult, (data) {
      try {
        final betResult = CrashAllBetsModel.fromJson(data);
        _betResultController.add(betResult);
      } catch (e) {
        log('afnas😴😴😴Error: $e');
      }
    });
  }

  void disconnect() {
    socket?.disconnect();
    socket?.destroy();
    _stateController.close();
    _tickController.close();
    _crashController.close();
    _betsController.close();
    _betResultController.close();
    _disconnectController.close();
    log('Socket disconnected');
  }

  // void disconnect() {
  //   socket?.disconnect();
  //   socket?.destroy();
  //   _stateController.close();
  //   _tickController.close();
  //   log('Socket disconnected');
  // }
}
