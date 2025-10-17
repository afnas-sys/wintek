import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:wintek/features/game/aviator/domain/models/rounds.dart';

class RecentRoundsService {
  final Dio dio;
  Timer? _timer;
  final StreamController<List<Rounds>> _roundsController =
      StreamController<List<Rounds>>.broadcast();

  RecentRoundsService(this.dio);

  Stream<List<Rounds>> get roundsStream => _roundsController.stream;

  void startListening({Duration interval = const Duration(seconds: 5)}) {
    fetchRecentRounds(); // Fetch immediately
    _timer = Timer.periodic(interval, (_) => fetchRecentRounds());
  }

  void stopListening() {
    _timer?.cancel();
    _roundsController.close();
  }

  Future<void> fetchRecentRounds() async {
    try {
      final response = await dio.get('app/aviator/rounds/recent?limit=15');
      final data = response.data;
      List<dynamic> roundsData;
      if (data is List) {
        roundsData = data;
      } else if (data is Map && data['rounds'] is List) {
        roundsData = data['rounds'];
      } else {
        throw Exception('Unexpected response format');
      }
      final rounds = roundsData.map((json) => Rounds.fromJson(json)).toList();
      _roundsController.add(rounds);
    } catch (e) {
      // Handle error, e.g., log or emit error event
      log('Error fetching recent rounds: $e');
    }
  }
}
