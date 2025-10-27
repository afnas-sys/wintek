import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/selection_container.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/features/game/card_jackpot/providers/checkout/amount_provider.dart';
import 'package:wintek/core/constants/app_strings.dart';
import 'package:wintek/core/constants/app_colors.dart';

class BottumSheet extends ConsumerWidget {
  final int cardIndex;
  final bool isMainCard;
  final int cardTypeIndex;
  BottumSheet({
    super.key,
    required this.cardIndex,
    this.isMainCard = false,
    required this.cardTypeIndex,
  });

  final List<int> multipleValues = [1, 5, 10, 20, 50, 100];
  final List<int> balanceValues = [10, 50, 100, 1000];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(amountSelectProvider);
    final selectionNotifier = ref.read(amountSelectProvider.notifier);
    final double width = MediaQuery.of(context).size.width;
    final cardName = isMainCard
        ? AppStrings.mainCardNames[cardIndex]
        : cardIndex;
    final String title = isMainCard
        ? 'SELECT ${AppStrings.mainCardTypeNames[cardTypeIndex]} $cardName'
        : 'SELECT ${AppStrings.mainCardTypeNames[cardTypeIndex]} $cardName';
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSecondPrimaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header section of the bottum sheet
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.cardPrimaryColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Center(
              child: AppText(
                text: title,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.cardSecondPrimaryColor,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 23),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Balance Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText(
                      text: 'Balance',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    Row(
                      children: List.generate(balanceValues.length, (index) {
                        final val = balanceValues[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: SelectContainer(
                            index: index,
                            selectedIndex: balanceValues.indexOf(
                              selection.walletValue,
                            ),
                            value: val.toString(),
                            onTap: () => selectionNotifier.selectWallet(val),
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Quantity Row
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText(
                      text: 'Quantity',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    Row(
                      children: [
                        // Decrease button untill 1
                        InkWell(
                          onTap: () {
                            if (selection.quantity > 1) {
                              selectionNotifier.selectQuantity(
                                selection.quantity - 1,
                              );
                            }
                          },
                          child: Container(
                            color: AppColors.cardPrimaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: const AppText(
                              text: '-',
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),

                        // Quantity display container
                        // increase quantity based on user interaction
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: AppText(
                            text: selection.quantity.toString(),
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        // Increase button from 1
                        InkWell(
                          onTap: () {
                            selectionNotifier.selectQuantity(
                              selection.quantity + 1,
                            );
                          },
                          child: Container(
                            color: AppColors.cardPrimaryColor,
                            padding: const EdgeInsets.symmetric(
                              // vertical: 2,
                              horizontal: 12,
                            ),
                            child: const AppText(
                              text: '+',
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Multipliers Row
                // while pressing the each multiplies button the amount will increase based on the selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(multipleValues.length, (index) {
                    final val = multipleValues[index];
                    final selectedIndex = multipleValues.indexOf(
                      selection.multiplier,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: SelectContainer(
                        index: index,
                        selectedIndex: selectedIndex,
                        value: 'X$val',
                        onTap: () => selectionNotifier.selectMultiplier(val),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // Bottum side of the bottumsheet contains two buttons - Back and Total Amount .
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back button
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: width * 0.45,
                      padding: const EdgeInsets.all(16),
                      color: Colors.black,
                      child: Center(
                        child: AppText(
                          text: 'BLACK',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.cardSecondPrimaryColor,
                        ),
                      ),
                    ),
                  ),

                  // Confirmation button
                  InkWell(
                    onTap: () {
                      // betNotifier.addRound(
                      //   cardName: cardName.toString(),
                      //   amount: selection.total,
                      // );
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: width * 0.55,
                      padding: const EdgeInsets.all(16),
                      color: Colors.amber,
                      child: Center(
                        child: AppText(
                          text: 'TOTAL AMOUNT : ${selection.total}',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.cardSecondPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
