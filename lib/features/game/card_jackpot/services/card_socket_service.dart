import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wintek/core/constants/socket_constants/socket_constants.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/balance_update_event.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/bet_result_event.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/round_end_event.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/round_new_event.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/socket/round_state_event.dart';
import 'package:wintek/features/game/card_jackpot/providers/history_provider.dart';
import 'package:wintek/features/game/card_jackpot/providers/round_provider.dart';
import 'package:wintek/features/game/card_jackpot/providers/wallet_provider.dart';

class CardSocketService {
  late IO.Socket socket;
  final CardRoundNotifier notifier;
  final Ref ref;
  final secureStorageService = SecureStorageService();
  CardSocketService(this.notifier, this.ref);

  void connect() async {
    final secureStorage = await secureStorageService.readCredentials();
    final token = secureStorage.token;
    socket = IO.io(
      SocketConstants.cardSocketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    socket.onConnect((_) {});

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
      // Trigger a re-fetch of the wallet balance
      ref.read(walletBalanceProvider.notifier).fetchWalletBalance();
    });

    // wallet:balance_update
    socket.on("wallet:balance_update", (data) {
      final event = BalanceUpdateEvent.fromJson(data);
      // Update wallet provider with new balance directly
      ref.read(walletBalanceProvider.notifier).updateBalance(event.balance);
    });

    // round:end
    socket.on("round:end", (data) {
      final event = RoundEndEvent.fromJson(data);
      notifier.updateRoundEnd(event);
      ref.read(gameHistoryProvider.notifier).fetchGameHistory(isRefresh: true);
      ref.read(myHistoryProvider.notifier).fetchMyHistory(isRefresh: true);
    });

    socket.onDisconnect((_) {});
  }

  void placeBet(Map<String, dynamic> bet) {
    socket.emit("place_bet", bet);
    // Fetch updated balance in case server deducted immediately
    Future.delayed(const Duration(milliseconds: 300), () {
      ref.read(walletBalanceProvider.notifier).fetchWalletBalance();
    });
    // notifier.setBetting(true);
  }

  void disconnect() {
    socket.disconnect();
  }
}
