import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/domain/selection/selection_model.dart';

final selectionProvider =
    StateNotifierProvider<SelectionNotifier, SelectionModel>((ref) {
      return SelectionNotifier();
    });

class SelectionNotifier extends StateNotifier<SelectionModel> {
  SelectionNotifier()
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
