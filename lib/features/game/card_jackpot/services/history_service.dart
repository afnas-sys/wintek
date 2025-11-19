import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/card_jackpot/domain/constants/api_constants.dart';

final historyServiceProvider = Provider<HistoryService>((ref) {
  final dio = ref.watch(dioProvider);
  return HistoryService(dio);
});

class HistoryService {
  final Dio _dio;

  HistoryService(this._dio);

  Future<List<Map<String, dynamic>>> fetchMyHistory() async {
    final secureData = await SecureStorageService().readCredentials();
    try {
      final response = await _dio.get(
        '${CardApiConstants.getMyHistory}${secureData.userId}',
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
      } else {
        throw Exception('Failed to fetch my history');
      }
    } catch (e) {
      throw Exception('Error fetching my history: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchGameHistory() async {
    try {
      final response = await _dio.get(CardApiConstants.recentRounds);
      if (response.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(
          response.data['data'] ?? [],
        );
        final filtered = data
            .map(
              (item) => {
                'sessionId': item['sessionId'],
                'winningCard': item['winningCard'],
              },
            )
            .toList();
        return filtered.take(20).toList();
      } else {
        throw Exception('Failed to fetch Game history');
      }
    } catch (e) {
      throw Exception('Error fetching game history: $e');
    }
  }
}
