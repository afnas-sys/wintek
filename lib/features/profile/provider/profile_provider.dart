import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/domain/model/user_data.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';

final profileProvider = FutureProvider<UserProfileData?>((ref) async {
  final service = SecureStorageService();
  final data = await service.readUserData();
  return data;
});
