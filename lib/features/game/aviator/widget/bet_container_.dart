import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/aviator/domain/models/bet_request.dart';
import 'package:wintek/features/game/aviator/providers/aviator_graph_provider.dart';
import 'package:wintek/features/game/aviator/providers/aviator_round_provider.dart';
import 'package:wintek/features/game/aviator/providers/bet_provider.dart';
import 'package:wintek/features/game/aviator/widget/custom_bet_button%20.dart';

class BetContainer extends ConsumerStatefulWidget {
  final int index;
  const BetContainer({super.key, required this.index});

  @override
  ConsumerState<BetContainer> createState() => _BetContainerState();
}

class _BetContainerState extends ConsumerState<BetContainer> {
  final _switchController = TextEditingController();
  int _selectedValue = 0;
  bool _isSwitched = false;
  final _amountController = TextEditingController();
  final _autoAmountController = TextEditingController();
  final secureStorageService = SecureStorageService();

  Future<String?> getUserId() async {
    final creds = await secureStorageService.readCredentials();
    return creds.userId; // this will be null if nothing was saved
  }

  void _setAmount(String value) {
    setState(() {
      if (_selectedValue == 0) {
        _amountController.text = value;
      } else {
        _autoAmountController.text = value;
      }
    });
  }

  void _increment() {
    int value = int.tryParse(_amountController.text) ?? 0;
    _amountController.text = (value + 1).toString();
  }

  void _decrement() {
    int value = int.tryParse(_amountController.text) ?? 0;
    if (value > 0) {
      _amountController.text = (value - 1).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    //!------BET CONTAINER------

    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      height: _selectedValue == 0 ? 210 : 258,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.aviatorFourteenthColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.aviatorFifteenthColor, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: SizedBox(width: 0, height: 0)),
              SizedBox(
                width: 191,
                height: 28,
                //! SWITCH
                child: CustomSlidingSegmentedControl<int>(
                  initialValue: _selectedValue,
                  children: {
                    0: Text(
                      'Bet',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorBodyMediumPrimary,
                    ),
                    1: Text(
                      'Auto',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorBodyMediumPrimary,
                    ),
                  },
                  decoration: BoxDecoration(
                    color: AppColors.aviatorFourteenthColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.aviatorFifteenthColor,
                      width: 1,
                    ),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: AppColors.aviatorFifteenthColor,
                    borderRadius: BorderRadius.circular(30),
                  ),

                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  onValueChanged: (v) {
                    setState(() => _selectedValue = v);
                  },
                ),
              ),
              //! TOP RIGHT SIDED BUTTON '-'
              CustomElevatedButton(
                hasBorder: true,
                borderColor: AppColors.aviatorFifteenthColor,
                backgroundColor: AppColors.aviatorFourteenthColor,
                padding: EdgeInsetsGeometry.all(2),
                height: 22,
                width: 22,
                onPressed: () {},
                child: Icon(
                  Icons.remove,
                  size: 18.33,
                  color: AppColors.aviatorFifteenthColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            child: Center(
              child: _selectedValue == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 16),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  //! container for Amount, + & - button
                                  SizedBox(
                                    width: 140,
                                    height: 36,
                                    child: TextField(
                                      cursorColor:
                                          AppColors.aviatorSixteenthColor,
                                      cursorHeight: 20,
                                      controller: _amountController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.aviatorHeadlineSmall,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 2,
                                              horizontal: 8,
                                            ),
                                        hintText: "1.00",
                                        hintStyle: Theme.of(
                                          context,
                                        ).textTheme.aviatorHeadlineSmall,
                                        filled: true,
                                        fillColor: AppColors.aviatorSixthColor,

                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            52,
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                AppColors.aviatorFifteenthColor,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            52,
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                AppColors.aviatorFifteenthColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            52,
                                          ),
                                          borderSide: BorderSide(),
                                        ),

                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomElevatedButton(
                                              hasBorder: false,
                                              backgroundColor: AppColors
                                                  .aviatorSixteenthColor,
                                              padding: const EdgeInsets.all(2),
                                              height: 22,
                                              width: 22,
                                              onPressed: _decrement,
                                              child: Icon(
                                                Icons.remove,
                                                size: 18.33,
                                                color:
                                                    AppColors.aviatorSixthColor,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            CustomElevatedButton(
                                              hasBorder: false,
                                              backgroundColor: AppColors
                                                  .aviatorSixteenthColor,
                                              padding: const EdgeInsets.all(2),
                                              height: 22,
                                              width: 22,
                                              onPressed: _increment,
                                              child: Icon(
                                                Icons.add,
                                                size: 18.33,
                                                color:
                                                    AppColors.aviatorSixthColor,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10),
                                  //! BUTTON FOR ₹10 & ₹20
                                  Row(
                                    children: [
                                      //Button for ₹10
                                      CustomElevatedButton(
                                        onPressed: () => _setAmount('10'),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        borderColor:
                                            AppColors.aviatorFifteenthColor,
                                        backgroundColor:
                                            AppColors.aviatorFourteenthColor,
                                        borderRadius: 30,
                                        height: 28,
                                        //   width: 74,
                                        elevation: 0,
                                        child: Text(
                                          '₹10',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.aviatorBodyMediumPrimary,
                                        ),
                                      ),

                                      SizedBox(width: 6),
                                      //Button for ₹20
                                      CustomElevatedButton(
                                        onPressed: () => _setAmount('20'),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        borderColor:
                                            AppColors.aviatorFifteenthColor,
                                        backgroundColor:
                                            AppColors.aviatorFourteenthColor,
                                        borderRadius: 30,
                                        height: 28,
                                        //   width: 74,
                                        elevation: 0,
                                        child: Text(
                                          '₹20',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.aviatorBodyMediumPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  //! BUTTON FOR ₹50 & ₹100
                                  Row(
                                    children: [
                                      CustomElevatedButton(
                                        onPressed: () => _setAmount('50'),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        borderColor:
                                            AppColors.aviatorFifteenthColor,
                                        backgroundColor:
                                            AppColors.aviatorFourteenthColor,
                                        borderRadius: 30,
                                        height: 28,
                                        // width: 74,
                                        elevation: 0,
                                        child: Text(
                                          '₹50',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.aviatorBodyMediumPrimary,
                                        ),
                                      ),

                                      SizedBox(width: 6),

                                      CustomElevatedButton(
                                        onPressed: () => _setAmount('100'),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        borderColor:
                                            AppColors.aviatorFifteenthColor,
                                        backgroundColor:
                                            AppColors.aviatorFourteenthColor,
                                        borderRadius: 30,
                                        height: 28,
                                        //  width: 74,
                                        elevation: 0,
                                        child: Text(
                                          '₹100',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.aviatorBodyMediumPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //  SizedBox(width: 20),
                        //! Manual BUTTON FOR BET
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomBetButton(
                                  index: widget.index,
                                  amountController: _amountController,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  //!   AUTO-------
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 16),
                        Expanded(
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  //! CONTAINER FOR AMOUNT, + & - button in AUTo
                                  SizedBox(
                                    width: 140,
                                    height: 36,
                                    child: TextField(
                                      cursorColor:
                                          AppColors.aviatorSixteenthColor,
                                      controller: _autoAmountController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.aviatorHeadlineSmall,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 2,
                                              horizontal: 8,
                                            ),
                                        hintText: "1.00",
                                        hintStyle: Theme.of(
                                          context,
                                        ).textTheme.aviatorHeadlineSmall,
                                        filled: true,
                                        fillColor: AppColors.aviatorSixthColor,

                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            52,
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                AppColors.aviatorFifteenthColor,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            52,
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                AppColors.aviatorFifteenthColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            52,
                                          ),
                                          borderSide: BorderSide(),
                                        ),

                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomElevatedButton(
                                              hasBorder: false,
                                              backgroundColor: AppColors
                                                  .aviatorSixteenthColor,
                                              padding: const EdgeInsets.all(2),
                                              height: 22,
                                              width: 22,
                                              onPressed: _decrement,
                                              child: Icon(
                                                Icons.remove,
                                                size: 18.33,
                                                color:
                                                    AppColors.aviatorSixthColor,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            CustomElevatedButton(
                                              hasBorder: false,
                                              backgroundColor: AppColors
                                                  .aviatorSixteenthColor,
                                              padding: const EdgeInsets.all(2),
                                              height: 22,
                                              width: 22,
                                              onPressed: _increment,
                                              child: Icon(
                                                Icons.add,
                                                size: 18.33,
                                                color:
                                                    AppColors.aviatorSixthColor,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  //!Auto BUTTON FOR AMOUNT 10 & 20
                                  Row(
                                    children: [
                                      CustomElevatedButton(
                                        onPressed: () => _setAmount('10'),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        borderColor:
                                            AppColors.aviatorFifteenthColor,
                                        backgroundColor:
                                            AppColors.aviatorFourteenthColor,
                                        borderRadius: 30,
                                        height: 28,
                                        //width: 74,
                                        elevation: 0,
                                        child: Text(
                                          '₹10',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.aviatorBodyMediumPrimary,
                                        ),
                                      ),

                                      SizedBox(width: 6),

                                      CustomElevatedButton(
                                        onPressed: () => _setAmount('20'),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        borderColor:
                                            AppColors.aviatorFifteenthColor,
                                        backgroundColor:
                                            AppColors.aviatorFourteenthColor,
                                        borderRadius: 30,
                                        height: 28,
                                        //  width: 74,
                                        elevation: 0,
                                        child: Text(
                                          '₹20',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.aviatorBodyMediumPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),

                                  //!Auto BUTTON FOR AMOUNT 50 &100
                                  Row(
                                    children: [
                                      CustomElevatedButton(
                                        onPressed: () => _setAmount('50'),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        borderColor:
                                            AppColors.aviatorFifteenthColor,
                                        backgroundColor:
                                            AppColors.aviatorFourteenthColor,
                                        borderRadius: 30,
                                        height: 28,
                                        // width: 74,
                                        elevation: 0,
                                        child: Text(
                                          '₹50',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.aviatorBodyMediumPrimary,
                                        ),
                                      ),

                                      SizedBox(width: 6),

                                      CustomElevatedButton(
                                        onPressed: () => _setAmount('100'),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        borderColor:
                                            AppColors.aviatorFifteenthColor,
                                        backgroundColor:
                                            AppColors.aviatorFourteenthColor,
                                        borderRadius: 30,
                                        height: 28,
                                        // width: 74,
                                        elevation: 0,
                                        child: Text(
                                          '₹100',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.aviatorBodyMediumPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //  SizedBox(width: 20),
                        //!Auto BUTTON FOR BET---------------------------------------------------
                        // Expanded(
                        //   child: CustomBetButton(
                        //     onBet: _placeAutoBet,
                        //     onCancel: _cancelAutoBet,
                        //     onCashout: _cashoutAutoBet,
                        //     state: _autoState,
                        //   ),
                        // ),
                      ],
                    ),
            ),
          ),

          SizedBox(height: 16),
          //! AUTOPLAY Button
          if (_selectedValue == 1)
            Row(
              children: [
                // AUTOPLAY button
                Flexible(
                  flex: 2,
                  child: CustomElevatedButton(
                    onPressed: () {},
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    borderRadius: 52,
                    backgroundColor: AppColors.aviatorNineteenthColor,
                    height: 28,
                    borderColor: AppColors.aviatorNineteenthColor,
                    child: Text(
                      'AUTOPLAY',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorBodyMediumPrimary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Right section (Auto Cash Out + Switch + TextField)
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      // Label
                      Expanded(
                        child: Text(
                          'Auto Cash Out',
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorbodySmallPrimary,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Switch
                      Transform.scale(
                        scale: 0.65,
                        child: Switch(
                          value: _isSwitched,
                          activeColor: AppColors.aviatorTertiaryColor,
                          inactiveThumbColor: AppColors.aviatorTertiaryColor,
                          activeTrackColor: AppColors.aviatorEighteenthColor,
                          inactiveTrackColor: AppColors.aviatorFourteenthColor,
                          onChanged: (value) {
                            setState(() {
                              _isSwitched = value;
                            });
                          },
                        ),
                      ),

                      // TextField
                      SizedBox(
                        width: 70,
                        height: 28,
                        child: TextField(
                          enabled: _isSwitched,
                          controller: _switchController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorBodyMediumSecondary,
                          decoration: InputDecoration(
                            suffixText: "X",
                            suffixStyle: TextStyle(
                              color: AppColors.aviatorSixteenthColor,
                            ),
                            hintText: "1.5",
                            filled: true,
                            fillColor: AppColors.aviatorSixthColor,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 6,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(52),
                              borderSide: BorderSide(
                                color: AppColors.aviatorFifteenthColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
