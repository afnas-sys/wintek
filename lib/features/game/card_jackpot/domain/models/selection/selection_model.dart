class SelectionModel {
  final int walletValue;
  final int quantity;
  final int multiplier;
  final int total;

  const SelectionModel({
    required this.walletValue,
    required this.quantity,
    required this.multiplier,
    required this.total,
  });

  SelectionModel copyWith({
    int? walletValue,
    int? quantity,
    int? multiplier,
    int? total,
  }) {
    final newWallet = walletValue ?? this.walletValue;
    final newQuantity = quantity ?? this.quantity;
    final newMultiplier = multiplier ?? this.multiplier;
    final newTotal =
        total ??
        (newWallet *
            (quantity ?? this.quantity) *
            (multiplier ?? this.multiplier));

    return SelectionModel(
      walletValue: newWallet,
      quantity: newQuantity,
      multiplier: newMultiplier,
      total: newTotal,
    );
  }
}
