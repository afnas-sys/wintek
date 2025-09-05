import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:wintek/utils/constants/app_colors.dart';
import 'package:wintek/utils/constants/theme.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';

class BetContainer extends StatefulWidget {
  const BetContainer({super.key});

  @override
  State<BetContainer> createState() => _BetContainerState();
}

class _BetContainerState extends State<BetContainer> {
  final _switchController = TextEditingController();
  int _selectedValue = 0;
  bool _isSwitched = false;
  bool _isPressed = false;

  final _amountController = TextEditingController();
  final _autoAmountController = TextEditingController();

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
                      children: [
                        SizedBox(height: 16),
                        Column(
                          children: [
                            //! container for Amount, + & - button
                            SizedBox(
                              width: 154,
                              height: 36,
                              child: TextField(
                                cursorColor: AppColors.aviatorSixteenthColor,
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 8,
                                  ),
                                  hintText: "1.00",
                                  hintStyle: Theme.of(
                                    context,
                                  ).textTheme.aviatorHeadlineSmall,
                                  filled: true,
                                  fillColor: AppColors.aviatorSixthColor,

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(52),
                                    borderSide: BorderSide(
                                      color: AppColors.aviatorFifteenthColor,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(52),
                                    borderSide: BorderSide(
                                      color: AppColors.aviatorFifteenthColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(52),
                                    borderSide: BorderSide(),
                                  ),

                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomElevatedButton(
                                        hasBorder: false,
                                        backgroundColor:
                                            AppColors.aviatorSixteenthColor,
                                        padding: const EdgeInsets.all(2),
                                        height: 22,
                                        width: 22,
                                        onPressed: _decrement,
                                        child: Icon(
                                          Icons.remove,
                                          size: 18.33,
                                          color: AppColors.aviatorSixthColor,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      CustomElevatedButton(
                                        hasBorder: false,
                                        backgroundColor:
                                            AppColors.aviatorSixteenthColor,
                                        padding: const EdgeInsets.all(2),
                                        height: 22,
                                        width: 22,
                                        onPressed: _increment,
                                        child: Icon(
                                          Icons.add,
                                          size: 18.33,
                                          color: AppColors.aviatorSixthColor,
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
                                CustomElevatedButton(
                                  onPressed: () => _setAmount('10'),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  borderColor: AppColors.aviatorFifteenthColor,
                                  backgroundColor:
                                      AppColors.aviatorFourteenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
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
                                  borderColor: AppColors.aviatorFifteenthColor,
                                  backgroundColor:
                                      AppColors.aviatorFourteenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
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
                                  borderColor: AppColors.aviatorFifteenthColor,
                                  backgroundColor:
                                      AppColors.aviatorFourteenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
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
                                  borderColor: AppColors.aviatorFifteenthColor,
                                  backgroundColor:
                                      AppColors.aviatorFourteenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
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
                        SizedBox(width: 20),
                        //! BUTTON FOR BET
                        _isPressed
                            ? CustomElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isPressed = !_isPressed;
                                  });
                                },
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                height: 108,
                                width: 171,
                                backgroundColor:
                                    AppColors.aviatorSeventeenthColor,
                                borderRadius: 20,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'CASHOUT',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.aviatorBodyTitleMdeium,
                                    ),
                                    Text(
                                      '249.00',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.aviatorHeadlineSmall,
                                    ),
                                  ],
                                ),
                              )
                            : CustomElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isPressed = !_isPressed;
                                  });
                                },

                                height: 108,
                                width: 171,
                                backgroundColor:
                                    AppColors.aviatorEighteenthColor,
                                borderRadius: 20,
                                child: Text(
                                  'BET',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.aviatorHeadlineSmall,
                                ),
                              ),
                      ],
                    )
                  //!   AUTO-------
                  : Row(
                      children: [
                        SizedBox(height: 16),
                        Column(
                          children: [
                            //! CONTAINER FOR AMOUNT, + & - button in AUTo
                            SizedBox(
                              width: 154,
                              height: 36,
                              child: TextField(
                                cursorColor: AppColors.aviatorSixteenthColor,
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 8,
                                  ),
                                  hintText: "1.00",
                                  hintStyle: Theme.of(
                                    context,
                                  ).textTheme.aviatorHeadlineSmall,
                                  filled: true,
                                  fillColor: AppColors.aviatorSixthColor,

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(52),
                                    borderSide: BorderSide(
                                      color: AppColors.aviatorFifteenthColor,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(52),
                                    borderSide: BorderSide(
                                      color: AppColors.aviatorFifteenthColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(52),
                                    borderSide: BorderSide(),
                                  ),

                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomElevatedButton(
                                        hasBorder: false,
                                        backgroundColor:
                                            AppColors.aviatorSixteenthColor,
                                        padding: const EdgeInsets.all(2),
                                        height: 22,
                                        width: 22,
                                        onPressed: _decrement,
                                        child: Icon(
                                          Icons.remove,
                                          size: 18.33,
                                          color: AppColors.aviatorSixthColor,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      CustomElevatedButton(
                                        hasBorder: false,
                                        backgroundColor:
                                            AppColors.aviatorSixteenthColor,
                                        padding: const EdgeInsets.all(2),
                                        height: 22,
                                        width: 22,
                                        onPressed: _increment,
                                        child: Icon(
                                          Icons.add,
                                          size: 18.33,
                                          color: AppColors.aviatorSixthColor,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            //! BUTTON FOR AMOUNT 10 & 20
                            Row(
                              children: [
                                CustomElevatedButton(
                                  onPressed: () => _setAmount('10'),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  borderColor: AppColors.aviatorFifteenthColor,
                                  backgroundColor:
                                      AppColors.aviatorFourteenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
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
                                  borderColor: AppColors.aviatorFifteenthColor,
                                  backgroundColor:
                                      AppColors.aviatorFourteenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
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

                            //! BUTTON FOR AMOUNT 50 &100
                            Row(
                              children: [
                                CustomElevatedButton(
                                  onPressed: () => _setAmount('50'),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  borderColor: AppColors.aviatorFifteenthColor,
                                  backgroundColor:
                                      AppColors.aviatorFourteenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
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
                                  borderColor: AppColors.aviatorFifteenthColor,
                                  backgroundColor:
                                      AppColors.aviatorFourteenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
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
                        SizedBox(width: 20),
                        //! BUTTON FOR BET---------------------------------------------------
                        _isPressed
                            ? CustomElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isPressed = !_isPressed;
                                  });
                                },
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                height: 108,
                                width: 171,
                                backgroundColor:
                                    AppColors.aviatorSeventeenthColor,
                                borderRadius: 20,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'CASHOUT',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.aviatorBodyTitleMdeium,
                                    ),
                                    Text(
                                      '249.00',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.aviatorHeadlineSmall,
                                    ),
                                  ],
                                ),
                              )
                            : CustomElevatedButton(
                                onPressed: () {
                                  _isPressed = !_isPressed;
                                },
                                height: 108,
                                width: 171,
                                backgroundColor:
                                    AppColors.aviatorEighteenthColor,
                                borderRadius: 20,
                                child: Text(
                                  'BET',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.aviatorHeadlineSmall,
                                ),
                              ),
                      ],
                    ),
            ),
          ),

          SizedBox(height: 16),
          //! AUTOPLAY Button
          if (_selectedValue == 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  onPressed: () {},
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  borderRadius: 52,
                  backgroundColor: AppColors.aviatorNineteenthColor,
                  width: 98,
                  height: 28,
                  borderColor: AppColors.aviatorNineteenthColor,
                  child: Text(
                    'AUTOPLAY',
                    style: Theme.of(context).textTheme.aviatorBodyMediumPrimary,
                  ),
                ),
                Row(
                  children: [
                    //! Auto cash oout Text
                    Text(
                      'Auto Cash Out',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorBodyMediumPrimary,
                    ),
                    //! Switch
                    SizedBox(width: 2),
                    Transform.scale(
                      scale: 0.70,
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
                    SizedBox(width: 2),
                    //! Button for 1.5 X
                    SizedBox(
                      width: 76,
                      height: 29,
                      child: TextField(
                        cursorColor: AppColors.aviatorSixteenthColor,
                        enabled: _isSwitched,
                        controller: _switchController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.aviatorBodyMediumSecondary,
                        decoration: InputDecoration(
                          suffix: Text(
                            'X',
                            style: TextStyle(
                              color: AppColors.aviatorSixteenthColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          hintText: "1.5",
                          hintStyle: Theme.of(
                            context,
                          ).textTheme.aviatorBodyMediumSecondary,
                          filled: true,
                          fillColor: AppColors.aviatorSixthColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(52),
                            borderSide: BorderSide(
                              color: AppColors.aviatorFifteenthColor,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(52),
                            borderSide: BorderSide(
                              color: AppColors.aviatorFifteenthColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(52),
                            borderSide: BorderSide(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
