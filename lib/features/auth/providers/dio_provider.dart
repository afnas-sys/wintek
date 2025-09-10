import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:wintek/features/auth/domain/constants/api_constants.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );
  return dio;
});
