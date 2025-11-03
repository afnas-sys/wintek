import 'package:wintek/core/constants/api_constants/api_constants.dart';

class CardApiConstants {
  static const String baseUrl = '${ApiContants.baseUrl}app/card';

  static final String getMyHistory = '$baseUrl/bets?user_id=';
  static const String getWalletBalance = '$baseUrl/user/balance?user_id=';
  static const String placeBet = '$baseUrl/bet/place';
  static const String recentRounds = '$baseUrl/rounds/recent';
}
