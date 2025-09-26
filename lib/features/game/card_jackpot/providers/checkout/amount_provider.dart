import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/domain/models/selection/selection_model.dart';

final amountSelectProvider =
    StateNotifierProvider<AmountSelectionNotifier, SelectionModel>((ref) {
      return AmountSelectionNotifier();
    });

class AmountSelectionNotifier extends StateNotifier<SelectionModel> {
  AmountSelectionNotifier()
    : super(
        const SelectionModel(
          walletValue: 10,
          quantity: 1,
          multiplier: 1,
          total: 10,
        ),
      );

  void selectWallet(int wallet) {
    state = state.copyWith(walletValue: wallet);
  }

  void selectQuantity(int qty) {
    state = state.copyWith(quantity: qty);
  }

  void selectMultiplier(int mult) {
    state = state.copyWith(multiplier: mult);
  }
}
