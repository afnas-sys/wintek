import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/aviator/widget/auto_play_widget.dart';

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
  final _autoPlayController = TextEditingController();
  final secureStorageService = SecureStorageService();

  Future<String?> getUserId() async {
    final creds = await secureStorageService.readCredentials();
    return creds.userId; // this will be null if nothing was saved
  }

  void _setAmount(String value) {
    setState(() {
      TextEditingController controller = _selectedValue == 0
          ? _amountController
          : _autoAmountController;
      int current = int.tryParse(controller.text) ?? 0;
      int add = int.tryParse(value) ?? 0;
      controller.text = (current + add).toString();
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
  void initState() {
    _amountController.text = 1.toString();
    _autoAmountController.text = 1.toString();
    super.initState();
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
                child: _buildSwitch(),
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
                                  _buildAmountTextField(
                                    context,
                                    _amountController,
                                  ),

                                  SizedBox(height: 10),
                                  //! BUTTON FOR ₹10 & ₹20
                                  Row(
                                    children: [
                                      _quickAmountButton(context, '₹10', '10'),
                                      const SizedBox(width: 6),
                                      _quickAmountButton(context, '₹20', '20'),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  //! BUTTON FOR ₹50 & ₹100
                                  Row(
                                    children: [
                                      _quickAmountButton(context, '₹50', '50'),
                                      const SizedBox(width: 6),
                                      _quickAmountButton(
                                        context,
                                        '₹100',
                                        '100',
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
                            children: [Expanded(child: _manualBetButton())],
                          ),
                        ),
                      ],
                    )
                  //!      ----------------------  AUTO---------------------------------
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
                                  _buildAmountTextField(
                                    context,
                                    _autoAmountController,
                                  ),

                                  SizedBox(height: 10),
                                  //!Auto BUTTON FOR AMOUNT 10 & 20
                                  Row(
                                    children: [
                                      _quickAmountButton(context, '₹10', '10'),
                                      const SizedBox(width: 6),
                                      _quickAmountButton(context, '₹20', '20'),
                                    ],
                                  ),
                                  SizedBox(height: 6),

                                  //!Auto BUTTON FOR AMOUNT 50 &100
                                  Row(
                                    children: [
                                      _quickAmountButton(context, '₹50', '50'),
                                      const SizedBox(width: 6),
                                      _quickAmountButton(
                                        context,
                                        '₹100',
                                        '100',
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
                        Expanded(child: _autoBetButton()),
                      ],
                    ),
            ),
          ),

          SizedBox(height: 16),
          //! AUTOPLAY Button
          if (_selectedValue == 1)
            Row(
              children: [
                //! AUTOPLAY button
                _buildAutoplayButton(context),
                // const SizedBox(width: 16),
                Spacer(),

                //! section (Auto Cash Out + Switch + TextField)
                _buildAutoCashOutRow(context),
              ],
            ),
        ],
      ),
    );
  }

  //!Switch
  Widget _buildSwitch() {
    return CustomSlidingSegmentedControl<int>(
      initialValue: _selectedValue,
      children: {
        0: Text(
          'Bet',
          style: Theme.of(context).textTheme.aviatorBodyMediumPrimary,
        ),
        1: Text(
          'Auto',
          style: Theme.of(context).textTheme.aviatorBodyMediumPrimary,
        ),
      },
      decoration: BoxDecoration(
        color: AppColors.aviatorFourteenthColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.aviatorFifteenthColor, width: 1),
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
    );
  }

  //!Auto BUTTON FOR AMOUNT
  Widget _buildAmountTextField(
    BuildContext context,
    TextEditingController controller,
  ) {
    return SizedBox(
      width: 140,
      height: 36,
      child: TextField(
        controller: controller,
        cursorColor: AppColors.aviatorSixteenthColor,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.aviatorHeadlineSmall,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 8,
          ),
          // hintText: "1.00",
          hintStyle: Theme.of(context).textTheme.aviatorHeadlineSmall,
          filled: true,
          fillColor: AppColors.aviatorSixthColor,
          enabledBorder: _borderStyle(),
          disabledBorder: _borderStyle(),
          focusedBorder: _borderStyle(),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconButton(Icons.remove, _decrement),
              const SizedBox(width: 4),
              _buildIconButton(Icons.add, _increment),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _borderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(52),
      borderSide: BorderSide(color: AppColors.aviatorFifteenthColor),
    );
  }

  //! IconButton
  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return CustomElevatedButton(
      hasBorder: false,
      backgroundColor: AppColors.aviatorSixteenthColor,
      padding: const EdgeInsets.all(2),
      height: 22,
      width: 22,
      onPressed: onPressed,
      child: Icon(icon, size: 18.33, color: AppColors.aviatorSixthColor),
    );
  }

  //!Quick Amount Button
  Widget _quickAmountButton(BuildContext context, String label, String value) {
    return CustomElevatedButton(
      onPressed: () => _setAmount(value),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      borderColor: AppColors.aviatorFifteenthColor,
      backgroundColor: AppColors.aviatorFourteenthColor,
      borderRadius: 30,
      height: 28,
      elevation: 0,
      child: Text(
        label,
        style: Theme.of(context).textTheme.aviatorBodyMediumPrimary,
      ),
    );
  }

  //!AUTOPLAY
  Widget _buildAutoplayButton(BuildContext context) {
    return Flexible(
      flex: 2,
      child: CustomElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AutoPlayWidget();
            },
          );
        },
        padding: const EdgeInsets.symmetric(horizontal: 12),
        borderRadius: 52,
        backgroundColor: AppColors.aviatorTwentyNinthColor,
        hasBorder: true,
        height: 28,
        borderColor: AppColors.aviatorNineteenthColor,
        child: Text(
          'AUTOPLAY',
          style: Theme.of(context).textTheme.aviatorBodyMediumPrimary,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  //!AUTO CASH OUT
  Widget _buildAutoCashOutRow(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Row(
        children: [
          // Label
          Expanded(
            child: Text(
              'Auto Cash Out',
              style: Theme.of(context).textTheme.aviatorbodySmallThird,
            ),
          ),
          // Switch
          Expanded(
            child: Transform.scale(
              scale: 0.65,
              child: Switch(
                value: _isSwitched,
                activeColor: AppColors.aviatorTertiaryColor,
                inactiveThumbColor: AppColors.aviatorTertiaryColor,
                activeTrackColor: AppColors.aviatorEighteenthColor,
                inactiveTrackColor: AppColors.aviatorFourteenthColor,
                onChanged: (value) => setState(() => _isSwitched = value),
              ),
            ),
          ),
          // TextField
          Expanded(
            child: SizedBox(
              width: 70,
              height: 28,
              child: TextField(
                enabled: _isSwitched,
                controller: _switchController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.aviatorBodyMediumSecondary,
                decoration: InputDecoration(
                  suffixText: "x",
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
                  border: _borderStyle(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //! MANUAL BET
  Widget _manualBetButton() {
    return CustomBetButton(
      index: widget.index,
      amountController: _amountController,
      //   switchController: _switchController,
    );
  }

  //! AUTO BET
  Widget _autoBetButton() {
    return CustomBetButton(
      index: widget.index,
      amountController: _autoAmountController,
      switchController: _switchController,
    );
  }
}
