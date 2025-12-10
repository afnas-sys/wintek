import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/selection_container.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/features/game/card_jackpot/providers/amount_provider.dart';
import 'package:wintek/features/game/card_jackpot/providers/bet_provider.dart';
import 'package:wintek/features/game/card_jackpot/providers/round_provider.dart';
import 'package:wintek/core/constants/app_strings.dart';
import 'package:wintek/core/constants/app_colors.dart';

class BottumSheet extends ConsumerStatefulWidget {
  final int cardIndex;
  final bool isMainCard;
  final int cardTypeIndex;
  const BottumSheet({
    super.key,
    required this.cardIndex,
    this.isMainCard = false,
    required this.cardTypeIndex,
  });

  @override
  ConsumerState<BottumSheet> createState() => _BottumSheetState();
}

class _BottumSheetState extends ConsumerState<BottumSheet> {
  final List<int> multipleValues = [1, 5, 10, 20, 50, 100];
  final List<int> balanceValues = [10, 50, 100, 1000];
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    final selection = ref.watch(amountSelectProvider);
    final selectionNotifier = ref.read(amountSelectProvider.notifier);
    final betNotifier = ref.read(betNotifierProvider.notifier);
    final sessionId = ref.watch(currentBetIdProvider);
    final roundEvent = ref.watch(cardRoundNotifierProvider);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final cardName = widget.isMainCard
        ? AppStrings.mainCardNames[widget.cardIndex]
        : widget.cardIndex;
    final String title = widget.isMainCard
        ? 'SELECT ${AppStrings.mainCardTypeNames[widget.cardTypeIndex]} $cardName'
        : 'SELECT ${AppStrings.mainCardTypeNames[widget.cardTypeIndex]} $cardName';

    // Responsive padding for content
    double horizontalPadding = width < 400 ? 15 : 30;
    double verticalPadding = height < 600 ? 15 : 23;

    return SafeArea(
      child: Container(
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
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Balance Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const AppText(
                        text: 'Balance',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(balanceValues.length, (
                              index,
                            ) {
                              final val = balanceValues[index];
                              return Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SelectContainer(
                                  index: index,
                                  selectedIndex: balanceValues.indexOf(
                                    selection.baseAmount,
                                  ),
                                  value: val.toString(),
                                  onTap: () =>
                                      selectionNotifier.selectWallet(val),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Quantity Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: const AppText(
                                text: '-',
                                fontSize: 22,
                                fontWeight: FontWeight.w300,
                                color: AppColors.cardSecondPrimaryColor,
                              ),
                            ),
                          ),

                          // Quantity display container
                          // increase quantity based on user interaction
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: EdgeInsets.symmetric(
                              horizontal: width < 400 ? 20 : 40,
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
                                horizontal: 12,
                              ),
                              child: const AppText(
                                text: '+',
                                fontSize: 22,
                                fontWeight: FontWeight.w300,
                                color: AppColors.cardSecondPrimaryColor,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 10,
                          runSpacing: 8,
                          children: List.generate(multipleValues.length, (
                            index,
                          ) {
                            final val = multipleValues[index];
                            final selectedIndex = multipleValues.indexOf(
                              selection.multiplier,
                            );
                            return SelectContainer(
                              index: index,
                              selectedIndex: selectedIndex,
                              value: 'X$val',
                              onTap: () =>
                                  selectionNotifier.selectMultiplier(val),
                            );
                          }),
                        ),
                      ),
                    ],
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
                            text: 'BACK',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.cardSecondPrimaryColor,
                          ),
                        ),
                      ),
                    ),

                    // Confirmation button
                    // Bet Button
                    GestureDetector(
                      onTap: _isLoading || _isSuccess
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                // Perform the bet request
                                await betNotifier.placeBet(
                                  cardName: cardName.toString(),
                                  amount: selection.totalAmount,
                                  sessionId: sessionId,
                                  roundId: roundEvent?.roundId ?? '',
                                  cardTypeIndex: widget.cardTypeIndex,
                                );

                                // Check if bet was successful
                                final betState = ref.read(betNotifierProvider);

                                if (betState.hasError) {
                                  // Show error message
                                  if (mounted) {
                                    _showSnackBar(
                                      context,
                                      betState.error.toString(),
                                      Colors.red,
                                    );
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                } else {
                                  // Show success animation
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                      _isSuccess = true;
                                    });

                                    // Haptic feedback for better feel
                                    HapticFeedback.mediumImpact();

                                    // Wait for animation to play before closing
                                    await Future.delayed(
                                      const Duration(milliseconds: 1000),
                                    );

                                    if (mounted) {
                                      // Reset amount selection after bet
                                      selectionNotifier.selectWallet(10);
                                      selectionNotifier.selectQuantity(1);
                                      selectionNotifier.selectMultiplier(1);
                                      Navigator.pop(context);

                                      // Optional: show a small snackbar after closing if needed
                                      // formatted for confirmation, though the button animation is primary.
                                      _showSnackBar(
                                        context,
                                        'Bet placed successfully!',
                                        AppColors.cardPrimaryColor,
                                      );
                                    }
                                  }
                                }
                              } catch (e) {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  _showSnackBar(
                                    context,
                                    'Failed to place bet. Please try again.',
                                    Colors.red,
                                  );
                                }
                              }
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: width * 0.55,
                        padding: const EdgeInsets.all(16),
                        color: _isSuccess
                            ? Colors.green
                            : AppColors.cardPrimaryColor,
                        curve: Curves.easeInOut,
                        child: Center(
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : _isSuccess
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const AppText(
                                      text: 'BET PLACED!',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                )
                              : AppText(
                                  text:
                                      'TOTAL AMOUNT : ${selection.totalAmount}',
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
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}
