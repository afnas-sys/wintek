import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/crash/domain/models/crash_recent_round_model.dart';

class CrashRecentRoundsService {
  final Dio dio;
  final SecureStorageService secureStorage;
  Timer? _timer;
  StreamController<List<CrashRecentRounds>> _roundsController =
      StreamController<List<CrashRecentRounds>>.broadcast();

  CrashRecentRoundsService(this.dio, this.secureStorage);

  Stream<List<CrashRecentRounds>> get roundsStream => _roundsController.stream;

  void startListening({Duration interval = const Duration(seconds: 5)}) {
    if (_roundsController.isClosed) {
      _roundsController = StreamController<List<CrashRecentRounds>>.broadcast();
    }
    fetchRecentRounds(); // Fetch immediately
    _timer = Timer.periodic(interval, (_) => fetchRecentRounds());
  }

  void stopListening() {
    _timer?.cancel();
    _roundsController.close();
  }

  Future<void> fetchRecentRounds() async {
    try {
      final credentials = await secureStorage.readCredentials();
      final response = await dio.get(
        'app/crash/rounds/recent?limit=50&id=${credentials.userId}',
        options: Options(headers: {'token': credentials.token}),
      );
      final data = response.data;
      List<dynamic> roundsData;
      if (data is List) {
        roundsData = data;
      } else if (data is Map && data['rounds'] is List) {
        roundsData = data['rounds'];
      } else {
        throw Exception('Unexpected response format');
      }
      final rounds = roundsData
          .map((json) => CrashRecentRounds.fromJson(json))
          .toList();
      if (!_roundsController.isClosed) {
        _roundsController.add(rounds);
      }
    } catch (e) {
      // Handle error, e.g., log or emit error event
      log('Error fetching recent rounds: $e');
    }
  }
}
