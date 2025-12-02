import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
