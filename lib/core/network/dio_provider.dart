import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:wintek/core/constants/api_constants/api_constants.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiContants.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );
  return dio;
});
