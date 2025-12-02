class CrashMyBetsModel {
  // final bool success;
  final List<MyBetsData> data;
  final int total;
  final int currentPage;
  final int totalPages;
  final int limit;

  CrashMyBetsModel({
    required this.data,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.limit,
  });

  factory CrashMyBetsModel.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List)
        .map((item) => MyBetsData.fromJson(item))
        .toList();

    // Helper to parse int safely
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    // If API doesn't provide pagination metadata, use fallback values
    final limit = parseInt(json['limit']) > 0 ? parseInt(json['limit']) : 50;
    final currentPage = parseInt(json['currentPage'] ?? json['page']) > 0
        ? parseInt(json['currentPage'] ?? json['page'])
        : 1;

    int total = parseInt(json['total'] ?? json['totalCount']);

    // If total is 0 but we have data, use data length at minimum
    if (total == 0 && dataList.isNotEmpty) {
      total = dataList.length;
    }

    // Calculate total pages
    int totalPages = parseInt(json['totalPages']);
    if (totalPages == 0) {
      // If we have a full page, assume there's at least one more page
      if (dataList.length >= limit) {
        totalPages = currentPage + 1;
      } else {
        totalPages = (total / limit).ceil();
      }
    }

    if (totalPages < currentPage) totalPages = currentPage;
    if (totalPages < 1) totalPages = 1;

    return CrashMyBetsModel(
      //success: json['success'],
      data: dataList,
      total: total,
      currentPage: currentPage,
      totalPages: totalPages,
      limit: limit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'success': success,
      'data': data.map((item) => item.toJson()).toList(),
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'limit': limit,
    };
  }
}

class MyBetsData {
  final String id;
  final Round roundId;
  final User user;
  final double stake;
  final String currency;
  final double? autoCashout;
  final int betIndex;
  final DateTime placedAt;
  final double cashoutAt;
  final DateTime cashedOutAt;
  final double payout;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  MyBetsData({
    required this.id,
    required this.roundId,
    required this.user,
    required this.stake,
    required this.currency,
    this.autoCashout,
    required this.betIndex,
    required this.placedAt,
    required this.cashoutAt,
    required this.cashedOutAt,
    required this.payout,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyBetsData.fromJson(Map<String, dynamic> json) {
    return MyBetsData(
      id: json['_id'],
      roundId: Round.fromJson(json['roundId']),
      user: User.fromJson(json['userId']),
      stake: json['stake'] != null ? (json['stake'] as num).toDouble() : 0.0,
      currency: json['currency'] ?? '',
      autoCashout: json['autoCashout'] != null
          ? (json['autoCashout'] as num).toDouble()
          : null,
      betIndex: json['betIndex'] ?? 0,
      placedAt: DateTime.tryParse(json['placedAt'] ?? '') ?? DateTime.now(),
      cashoutAt: json['cashoutAt'] != null
          ? (json['cashoutAt'] as num).toDouble()
          : 0.0,
      cashedOutAt:
          DateTime.tryParse(json['cashedOutAt'] ?? '') ?? DateTime.now(),
      payout: json['payout'] != null ? (json['payout'] as num).toDouble() : 0.0,
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'roundId': roundId.toJson(),
      'userId': user.toJson(),
      'stake': stake,
      'currency': currency,
      'autoCashout': autoCashout,
      'betIndex': betIndex,
      'placedAt': placedAt.toIso8601String(),
      'cashoutAt': cashoutAt,
      'cashedOutAt': cashedOutAt.toIso8601String(),
      'payout': payout,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Round {
  final String id;
  final int seq;
  final String state;
  final DateTime startedAt;
  final double crashAt;
  final DateTime endedAt;

  Round({
    required this.id,
    required this.seq,
    required this.state,
    required this.startedAt,
    required this.crashAt,
    required this.endedAt,
  });

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      id: json['_id'] ?? '',
      seq: json['seq'] ?? 0,
      state: json['state'] ?? '',
      startedAt: DateTime.tryParse(json['startedAt'] ?? '') ?? DateTime.now(),
      crashAt: json['crashAt'] != null
          ? (json['crashAt'] as num).toDouble()
          : 0.0,
      endedAt: DateTime.tryParse(json['endedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'seq': seq,
      'state': state,
      'startedAt': startedAt.toIso8601String(),
      'crashAt': crashAt,
      'endedAt': endedAt.toIso8601String(),
    };
  }
}

class User {
  final String id;
  final String userName;
  final String? email;

  User({required this.id, required this.userName, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      userName: json['user_name'] ?? '',
      email: json['email'], // will be null if not present
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'user_name': userName, 'email': email};
  }
}
