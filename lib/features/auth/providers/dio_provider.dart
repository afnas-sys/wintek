import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://ank143matkaapp.info/api/v1/',
      headers: {'Content-Type': 'application/json'},
    ),
  );
  return dio;
});
