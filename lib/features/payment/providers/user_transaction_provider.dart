import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/payment/domain/models/user_transaction_response_model.dart';
import 'package:wintek/features/payment/services/user_transaction_service.dart';

class UserTransactionNotifier
    extends StateNotifier<AsyncValue<UserTransactionResponseModel?>> {
  final UserTransactionService _service;

  UserTransactionNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> fetchUserTransactions(int skip, int count) async {
    state = const AsyncValue.loading();
    try {
      final response = await _service.getUserTransactions(skip, count);
      state = AsyncValue.data(response);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final userTransactionProvider =
    StateNotifierProvider<
      UserTransactionNotifier,
      AsyncValue<UserTransactionResponseModel?>
    >((ref) {
      final service = ref.watch(userTransactionServiceProvider);
      return UserTransactionNotifier(service);
    });
