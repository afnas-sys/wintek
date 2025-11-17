import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';

class AutoPlaySettings {
  final String? selectedRounds;
  final bool stopIfCashDecreases;
  final double decrementAmount;
  final bool stopIfCashIncreases;
  final double incrementAmount;
  final bool stopIfSingleWinExceeds;
  final double exceedsAmount;

  AutoPlaySettings({
    required this.selectedRounds,
    required this.stopIfCashDecreases,
    required this.decrementAmount,
    required this.stopIfCashIncreases,
    required this.incrementAmount,
    required this.stopIfSingleWinExceeds,
    required this.exceedsAmount,
  });
}

class AutoPlayWidget extends StatefulWidget {
  final Function(AutoPlaySettings)? onStart;

  const AutoPlayWidget({super.key, this.onStart});

  @override
  State<AutoPlayWidget> createState() => _AutoPlayWidgetState();
}

class _AutoPlayWidgetState extends State<AutoPlayWidget> {
  String? selectedRounds;
  bool stopIfCashDecreases = false;
  bool stopIfCashIncreases = false;
  bool stopIfSingleWinExceeds = false;
  final _decrementController = TextEditingController(text: '0.00');
  final _incrementController = TextEditingController(text: '0.00');
  final _exceedsController = TextEditingController(text: '0.00');

  // Validation error messages
  String? _roundsError;
  String? _conditionsError;
  String? _decrementError;
  String? _incrementError;
  String? _exceedsError;

  void _startAutoPlay() {
    // Clear previous errors
    setState(() {
      _roundsError = null;
      _conditionsError = null;
      _decrementError = null;
      _incrementError = null;
      _exceedsError = null;
    });

    bool hasErrors = false;

    // Validation: Check if rounds are selected
    if (selectedRounds == null) {
      setState(() => _roundsError = 'Please, set number of rounds');
      hasErrors = true;
    }

    // Validation: Check if at least one condition is enabled
    if (!stopIfCashDecreases &&
        !stopIfCashIncreases &&
        !stopIfSingleWinExceeds) {
      setState(
        () =>
            _conditionsError = 'Please, specify decrease or exceed stop point',
      );
      hasErrors = true;
    }

    // Validation: Check if enabled conditions have valid amounts
    if (stopIfCashDecreases) {
      final amount = double.tryParse(_decrementController.text) ?? 0.0;
      if (amount <= 0) {
        setState(() => _decrementError = 'Enter valid amount');
        hasErrors = true;
      }
    }

    if (stopIfCashIncreases) {
      final amount = double.tryParse(_incrementController.text) ?? 0.0;
      if (amount <= 0) {
        setState(() => _incrementError = 'Enter valid amount');
        hasErrors = true;
      }
    }

    if (stopIfSingleWinExceeds) {
      final amount = double.tryParse(_exceedsController.text) ?? 0.0;
      if (amount <= 0) {
        setState(() => _exceedsError = 'Enter valid amount');
        hasErrors = true;
      }
    }

    if (hasErrors) return;

    final settings = AutoPlaySettings(
      selectedRounds: selectedRounds,
      stopIfCashDecreases: stopIfCashDecreases,
      decrementAmount: double.tryParse(_decrementController.text) ?? 0.0,
      stopIfCashIncreases: stopIfCashIncreases,
      incrementAmount: double.tryParse(_incrementController.text) ?? 0.0,
      stopIfSingleWinExceeds: stopIfSingleWinExceeds,
      exceedsAmount: double.tryParse(_exceedsController.text) ?? 0.0,
    );

    // Call the callback if provided, otherwise pop with settings
    if (widget.onStart != null) {
      widget.onStart!(settings);
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop(settings);
    }
  }

  void _increment(TextEditingController controller) {
    final currentValue = double.tryParse(controller.text) ?? 0.0;
    final newValue = currentValue + 1.0;
    setState(() {
      controller.text = newValue.toStringAsFixed(0);
    });
  }

  void _decrement(TextEditingController controller) {
    final currentValue = double.tryParse(controller.text) ?? 0.0;
    final newValue = (currentValue - 1.0).clamp(0.0, double.infinity);
    setState(() {
      controller.text = newValue.toStringAsFixed(0);
    });
  }

  void _resetAll() {
    setState(() {
      selectedRounds = null;
      stopIfCashDecreases = false;
      stopIfCashIncreases = false;
      stopIfSingleWinExceeds = false;
      _decrementController.text = '0.00';
      _incrementController.text = '0.00';
      _exceedsController.text = '0.00';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: AlertDialog(
        backgroundColor: AppColors.aviatorThirtyFirstColor,
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(
          height: 450,
          width: double.maxFinite,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.aviatorFourteenthColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              spacing: 2,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.aviatorThirtyFourColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Auto play options',
                        style: Theme.of(
                          context,
                        ).textTheme.aviatorBodyMediumPrimary,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          color: AppColors.aviatorTertiaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Rounds
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.aviatorThirtyFourColor,
                      borderRadius: BorderRadius.circular(20),
                      border: _roundsError != null
                          ? Border.all(
                              color: AppColors.aviatorThirtyTwoColor,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 6,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Number of rounds:',
                              style: Theme.of(
                                context,
                              ).textTheme.aviatorBodyMediumPrimary,
                            ),
                            if (_roundsError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  _roundsError!,
                                  style: const TextStyle(
                                    color: AppColors.aviatorThirtyThreeColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _autoPlayButton(context, '10'),
                            _autoPlayButton(context, '20'),
                            _autoPlayButton(context, '50'),
                            _autoPlayButton(context, '100'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                //!cash Decrease
                autoPlayCondition(
                  'Stop if cash decreases by',
                  _decrementController,
                  stopIfCashDecreases,
                  (value) {
                    setState(() {
                      stopIfCashDecreases = value;
                      // Clear error when switch is toggled
                      if (!value) _decrementError = null;
                      // Clear general conditions error when at least one condition is enabled
                      if (value ||
                          stopIfCashIncreases ||
                          stopIfSingleWinExceeds) {
                        _conditionsError = null;
                      }
                    });
                  },
                  errorText: _decrementError,
                ),
                SizedBox(height: 2),
                //!cash Increase
                autoPlayCondition(
                  'Stop if cash increase by',
                  _incrementController,
                  stopIfCashIncreases,
                  (value) {
                    setState(() {
                      stopIfCashIncreases = value;
                      // Clear error when switch is toggled
                      if (!value) _incrementError = null;
                      // Clear general conditions error when at least one condition is enabled
                      if (value ||
                          stopIfCashDecreases ||
                          stopIfSingleWinExceeds) {
                        _conditionsError = null;
                      }
                    });
                  },
                  errorText: _incrementError,
                ),
                SizedBox(height: 2),

                //!single win exceeds
                autoPlayCondition(
                  'Stop if single win exceeds',
                  _exceedsController,
                  stopIfSingleWinExceeds,
                  (value) {
                    setState(() {
                      stopIfSingleWinExceeds = value;
                      // Clear error when switch is toggled
                      if (!value) _exceedsError = null;
                      // Clear general conditions error when at least one condition is enabled
                      if (value || stopIfCashDecreases || stopIfCashIncreases) {
                        _conditionsError = null;
                      }
                    });
                  },
                  errorText: _exceedsError,
                ),

                // General conditions error
                if (_conditionsError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      _conditionsError!,
                      style: const TextStyle(
                        color: AppColors.aviatorThirtyThreeColor,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 20),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.aviatorThirtyFourColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: CustomElevatedButton(
                            borderRadius: 100,
                            width: 100,
                            hasBorder: true,
                            borderColor: AppColors.aviatorSeventeenthColor,
                            backgroundColor: AppColors.aviatorSeventeenthColor,
                            onPressed: _resetAll,
                            padding: EdgeInsets.only(
                              left: 23,
                              right: 23,
                              top: 4,
                              bottom: 4,
                            ),
                            child: Text(
                              'Reset',
                              style: Theme.of(
                                context,
                              ).textTheme.aviatorBodyTitleMdeium,
                            ),
                          ),
                        ),
                        Flexible(
                          child: CustomElevatedButton(
                            borderRadius: 100,
                            width: 100,
                            hasBorder: true,
                            borderColor: AppColors.aviatorEighteenthColor,
                            backgroundColor: AppColors.aviatorEighteenthColor,
                            onPressed: _startAutoPlay,
                            padding: EdgeInsets.only(
                              left: 23,
                              right: 23,
                              top: 4,
                              bottom: 4,
                            ),
                            child: Text(
                              'Start',
                              style: Theme.of(
                                context,
                              ).textTheme.aviatorBodyTitleMdeium,
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
        ),
      ),
    );
  }

  Widget autoPlayCondition(
    String label,
    TextEditingController controller,
    bool switchValue,
    Function(bool) onSwitchChanged, {
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.aviatorThirtyFourColor,
          borderRadius: BorderRadius.circular(20),
          border: errorText != null
              ? Border.all(color: AppColors.aviatorThirtyThreeColor, width: 2)
              : null,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  //! Switch
                  child: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: switchValue,
                      onChanged: onSwitchChanged,
                      thumbColor: WidgetStatePropertyAll(
                        switchValue
                            ? AppColors.aviatorSixteenthColor
                            : AppColors.aviatorTwentySecondColor,
                      ),
                      trackOutlineColor: WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      activeColor: AppColors.aviatorFourteenthColor,
                      inactiveThumbColor: AppColors.aviatorThirtyColor,

                      inactiveTrackColor: AppColors.aviatorFourteenthColor,
                    ),
                  ),
                ),
                //! Label
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.aviatorbodySmallPrimary
                        .copyWith(
                          color: switchValue
                              ? null
                              : AppColors.aviatorThirtyColor,
                        ),
                  ),
                ),
                //! TextField
                Expanded(
                  child: _buildAmountTextField(
                    context,
                    controller,
                    enabled: switchValue,
                  ),
                ),
                SizedBox(width: 5),

                Text(
                  'INR',
                  style: Theme.of(context).textTheme.aviatorbodySmallPrimary,
                ),
              ],
            ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  errorText,
                  style: const TextStyle(
                    color: AppColors.aviatorThirtyThreeColor,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _autoPlayButton(BuildContext context, String label) {
    return CustomElevatedButton(
      onPressed: () {
        setState(() {
          selectedRounds = label;
          // Clear rounds error when a round is selected
          _roundsError = null;
        });
      },
      width: 50,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      borderColor: AppColors.aviatorFifteenthColor,
      backgroundColor: AppColors.aviatorFourteenthColor,
      borderRadius: 50,
      height: 28,
      elevation: 0,
      isSelected: selectedRounds == label,
      selectedBackgroundColor: AppColors.aviatorFifteenthColor,
      child: Text(
        label,
        style: Theme.of(context).textTheme.aviatorBodyMediumPrimary,
      ),
    );
  }

  Widget _buildAmountTextField(
    BuildContext context,
    TextEditingController controller, {
    bool enabled = true,
  }) {
    return SizedBox(
      width: 120,
      height: 36,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.aviatorSixthColor
              : AppColors.aviatorSixthColor,
          borderRadius: BorderRadius.circular(52),
        ),
        child: Row(
          children: [
            _buildIconButton(
              Icons.remove,
              enabled ? () => _decrement(controller) : () {},
              enabled: enabled,
            ),

            Expanded(
              child: TextField(
                cursorHeight: 12,
                controller: controller,
                enabled: enabled,
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: Theme.of(context).textTheme.aviatorBodyMediumPrimary
                    .copyWith(color: enabled ? null : Colors.grey),
                cursorColor: enabled
                    ? AppColors.aviatorTertiaryColor
                    : AppColors.aviatorTwentySecondColor,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 10),

                  hintStyle: Theme.of(context).textTheme.aviatorbodySmallPrimary
                      .copyWith(color: enabled ? null : Colors.grey),
                  filled: true,
                  fillColor: enabled
                      ? AppColors.aviatorSixthColor
                      : AppColors.aviatorSixthColor,
                  border: InputBorder.none,
                ),
              ),
            ),

            _buildIconButton(
              Icons.add,
              enabled ? () => _increment(controller) : () {},
              enabled: enabled,
            ),
          ],
        ),
      ),
    );
  }

  //! IconButton
  Widget _buildIconButton(
    IconData icon,
    VoidCallback onPressed, {
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: CustomElevatedButton(
        hasBorder: false,
        backgroundColor: enabled
            ? AppColors.aviatorFifteenthColor
            : AppColors.aviatorFifteenthColor,
        padding: EdgeInsetsGeometry.only(left: 0, right: 0, top: 0, bottom: 0),
        onPressed: onPressed,
        height: 22,
        width: 22,
        borderRadius: 100,
        child: Center(
          child: Icon(
            icon,
            size: 18.33,
            color: enabled
                ? AppColors.aviatorTertiaryColor
                : AppColors.aviatorThirtyColor,
          ),
        ),
      ),
    );
  }
}
