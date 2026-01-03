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
  //
  //
  //
  // Fetch My History
  //
  //
  //
  Future<List<Map<String, dynamic>>> fetchMyHistory({
    int page = 1,
    int limit = 10,
  }) async {
    final secureData = await SecureStorageService().readCredentials();
    final skip = (page - 1) * limit;
    try {
      final response = await _dio.get(
        '${CardApiConstants.getMyHistory}${secureData.userId}',
        queryParameters: {'skip': skip, 'limit': limit},
        options: Options(
          headers: {'Authorization': 'Bearer ${secureData.token}'},
        ),
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

  //
  //
  //
  // Fetch Game History
  //
  //
  //
  //
  Future<List<Map<String, dynamic>>> fetchGameHistory({
    int page = 1,
    int limit = 20,
  }) async {
    final secureData = await SecureStorageService().readCredentials();
    final skip = (page - 1) * limit;
    try {
      final response = await _dio.get(
        CardApiConstants.recentRounds,
        queryParameters: {'skip': skip, 'limit': limit},
        options: Options(
          headers: {'Authorization': 'Bearer ${secureData.token}'},
        ),
      );
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
        return filtered;
      } else {
        throw Exception('Failed to fetch Game history');
      }
    } catch (e) {
      throw Exception('Error fetching game history: $e');
    }
  }
}
