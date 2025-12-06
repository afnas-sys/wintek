import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wintek/features/game/aviator/domain/models/bet_response.dart';

class AviatorBetCacheService {
  static const String _betKeyPrefix = 'aviator_bet_';

  Future<void> saveBet(int index, BetResponse bet) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(bet.toJson());
    await prefs.setString('$_betKeyPrefix$index', jsonString);
    log('Saved bet for index $index: $jsonString');
  }

  Future<BetResponse?> getBet(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('$_betKeyPrefix$index');
    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString);
        log('Retrieved bet for index $index: $jsonString');
        return BetResponse.fromJson(jsonMap);
      } catch (e) {
        log('Error decoding bet for index $index: $e');
        return null;
      }
    }
    log('No bet found for index $index');
    return null;
  }

  Future<void> clearBet(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_betKeyPrefix$index');
    log('Cleared bet for index $index');
  }

  // Auto Play Caching
  static const String _autoPlayKeyPrefix = 'aviator_autoplay_';

  Future<void> saveAutoPlayState(int index, Map<String, dynamic> state) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(state);
    await prefs.setString('$_autoPlayKeyPrefix$index', jsonString);
    log('Saved auto play state for index $index: $jsonString');
  }

  Future<Map<String, dynamic>?> getAutoPlayState(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('$_autoPlayKeyPrefix$index');
    if (jsonString != null) {
      try {
        log('Retrieved auto play state for index $index: $jsonString');
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        log('Error decoding auto play state for index $index: $e');
        return null;
      }
    }
    log('No auto play state found for index $index');
    return null;
  }

  Future<void> clearAutoPlayState(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_autoPlayKeyPrefix$index');
    log('Cleared auto play state for index $index');
  }
}
