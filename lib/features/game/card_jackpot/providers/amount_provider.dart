import 'package:flutter_riverpod/flutter_riverpod.dart';

final amountSelectProvider =
    StateNotifierProvider<AmountSelectionNotifier, BetAmountModel>((ref) {
      return AmountSelectionNotifier();
    });

class AmountSelectionNotifier extends StateNotifier<BetAmountModel> {
  AmountSelectionNotifier()
    : super(
        const BetAmountModel(
          baseAmount: 10,
          quantity: 1,
          multiplier: 1,
          totalAmount: 10,
        ),
      );

  void selectWallet(int wallet) {
    state = state.copyWith(baseAmount: wallet);
  }

  void selectQuantity(int qty) {
    state = state.copyWith(quantity: qty);
  }

  void selectMultiplier(int mult) {
    state = state.copyWith(multiplier: mult);
  }
}

// model

class BetAmountModel {
  final int baseAmount;
  final int quantity;
  final int multiplier;
  final int totalAmount;

  const BetAmountModel({
    required this.baseAmount,
    required this.quantity,
    required this.multiplier,
    required this.totalAmount,
  });

  BetAmountModel copyWith({
    int? baseAmount,
    int? quantity,
    int? multiplier,
    int? totalAmount,
  }) {
    final newBaseAmount = baseAmount ?? this.baseAmount;
    final newQuantity = quantity ?? this.quantity;
    final newMultiplier = multiplier ?? this.multiplier;
    final newTotalAmount =
        totalAmount ?? (newBaseAmount * newQuantity * newMultiplier);

    return BetAmountModel(
      baseAmount: newBaseAmount,
      quantity: newQuantity,
      multiplier: newMultiplier,
      totalAmount: newTotalAmount,
    );
  }
}
