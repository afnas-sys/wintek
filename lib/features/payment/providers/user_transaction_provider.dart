import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/payment/domain/models/user_transaction_response_model.dart';
import 'package:wintek/features/payment/services/user_transaction_service.dart';

class UserTransactionNotifier
    extends StateNotifier<AsyncValue<UserTransactionResponseModel?>> {
  final UserTransactionService _service;

  int _skip = 0;
  final int _limit = 10;
  bool _isLoadingMore = false;

  UserTransactionNotifier(this._service) : super(const AsyncValue.loading());

  bool get isLoadingMore => _isLoadingMore;

  /// initial fetch
  Future<void> fetchUserTransactions(int skip, int count) async {
    try {
      final response = await _service.getUserTransactions(skip, count);
      state = AsyncValue.data(response);
      _skip = count;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// fetch all transactions
  Future<void> fetchAllUserTransactions() async {
    try {
      final response = await _service.getUserTransactions(
        0,
        0,
      ); // Assuming 0 means all
      state = AsyncValue.data(response);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// load next page
  Future<void> loadMoreTransactions() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;

    try {
      final currentState = state.value;
      final response = await _service.getUserTransactions(_skip, _limit);

      if (currentState != null) {
        final updatedList = [...currentState.data, ...response.data];

        final updated = UserTransactionResponseModel(
          status: 'success',
          total: response.total,
          data: updatedList,
        );

        state = AsyncValue.data(updated);
      } else {
        state = AsyncValue.data(response);
      }

      _skip += _limit;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _isLoadingMore = false;
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
