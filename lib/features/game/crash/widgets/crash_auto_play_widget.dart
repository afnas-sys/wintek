import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';

class CrashAutoPlayWidget {
  final int selectedRounds;
  final double autoCashoutMultiplier;

  CrashAutoPlayWidget({
    required this.selectedRounds,
    required this.autoCashoutMultiplier,
  });
}

class AutoPlayWidget extends StatefulWidget {
  final Function(CrashAutoPlayWidget)? onStart;

  const AutoPlayWidget({super.key, this.onStart});

  @override
  State<AutoPlayWidget> createState() => _CrashAutoPlayWidgetState();
}

class _CrashAutoPlayWidgetState extends State<AutoPlayWidget> {
  int selectedRounds = 10;
  final _autoCashoutController = TextEditingController(text: '2.0');

  // Validation error messages
  String? _roundsError;
  String? _autoCashoutError;

  void _startAutoPlay() {
    // Clear previous errors
    setState(() {
      _roundsError = null;
      _autoCashoutError = null;
    });

    bool hasErrors = false;

    // Validation: Check if auto cashout multiplier is valid
    final autoCashoutValue =
        double.tryParse(_autoCashoutController.text) ?? 0.0;
    if (autoCashoutValue <= 1.0) {
      setState(
        () => _autoCashoutError = 'Auto cashout must be greater than 1.0x',
      );
      hasErrors = true;
    }

    if (hasErrors) return;

    final settings = CrashAutoPlayWidget(
      selectedRounds: selectedRounds,
      autoCashoutMultiplier: autoCashoutValue,
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
      selectedRounds = 10;
      _autoCashoutController.text = '2.0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: AlertDialog(
        backgroundColor: AppColors.crashTwentyThirdColor,
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(
          height: 450,
          width: double.maxFinite,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.crashEleventhColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              spacing: 2,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.crashSeventeenthColor,
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
                        ).textTheme.crashBodyMediumPrimary,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          color: AppColors.crashPrimaryColor,
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
                      color: AppColors.crashSeventeenthColor,
                      borderRadius: BorderRadius.circular(20),
                      border: _roundsError != null
                          ? Border.all(
                              color: AppColors.crashEighteenthColor,
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
                              ).textTheme.crashBodyMediumPrimary,
                            ),
                            if (_roundsError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  _roundsError!,
                                  style: const TextStyle(
                                    color: AppColors.crashNinteenthColor,
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

                // Auto Cashout Multiplier
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.crashSeventeenthColor,
                      borderRadius: BorderRadius.circular(20),
                      border: _autoCashoutError != null
                          ? Border.all(
                              color: AppColors.crashNinteenthColor,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Auto Cashout at',
                                style: Theme.of(
                                  context,
                                ).textTheme.crashbodySmallPrimary,
                              ),
                            ),
                            Expanded(
                              child: _buildAmountTextField(
                                context,
                                _autoCashoutController,
                                enabled: true,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'x',
                              style: Theme.of(
                                context,
                              ).textTheme.crashbodySmallPrimary,
                            ),
                          ],
                        ),
                        if (_autoCashoutError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              _autoCashoutError!,
                              style: const TextStyle(
                                color: AppColors.crashNinteenthColor,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.crashSeventeenthColor,
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
                            borderColor: AppColors.crashFourteenthColor,
                            backgroundColor: AppColors.crashFourteenthColor,
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
                              ).textTheme.crashBodyTitleMdeium,
                            ),
                          ),
                        ),
                        Flexible(
                          child: CustomElevatedButton(
                            borderRadius: 100,
                            width: 100,
                            hasBorder: true,
                            borderColor: AppColors.crashFifteenthColor,
                            backgroundColor: AppColors.crashFifteenthColor,
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
                              ).textTheme.crashBodyTitleMdeium,
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
          color: AppColors.crashSeventeenthColor,
          borderRadius: BorderRadius.circular(20),
          border: errorText != null
              ? Border.all(color: AppColors.crashNinteenthColor, width: 2)
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
                            ? AppColors.crashThirteenthColor
                            : AppColors.crashTwentythColor,
                      ),
                      trackOutlineColor: WidgetStatePropertyAll(
                        AppColors.crashTwentyFirstColor,
                      ),
                      activeColor: AppColors.crashEleventhColor,
                      inactiveThumbColor: AppColors.crashTwentySecondColor,

                      inactiveTrackColor: AppColors.crashEleventhColor,
                    ),
                  ),
                ),
                //! Label
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.crashbodySmallPrimary
                        .copyWith(
                          color: switchValue
                              ? null
                              : AppColors.crashTwentySecondColor,
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
                  style: Theme.of(context).textTheme.crashbodySmallPrimary,
                ),
              ],
            ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  errorText,
                  style: const TextStyle(
                    color: AppColors.crashNinteenthColor,
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
          selectedRounds = int.parse(label);
          // Clear rounds error when a round is selected
          _roundsError = null;
        });
      },
      width: 50,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      borderColor: AppColors.crashTwelfthColor,
      backgroundColor: AppColors.crashEleventhColor,
      borderRadius: 50,
      height: 28,
      elevation: 0,
      isSelected: selectedRounds == int.parse(label),
      selectedBackgroundColor: AppColors.crashTwelfthColor,
      child: Text(
        label,
        style: Theme.of(context).textTheme.crashBodyMediumPrimary,
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
              ? AppColors.crashSecondaryColor
              : AppColors.crashSecondaryColor,
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
                style: Theme.of(context).textTheme.crashBodyMediumPrimary
                    .copyWith(
                      color: enabled ? null : AppColors.crashFifthColor,
                    ),
                cursorColor: enabled
                    ? AppColors.crashPrimaryColor
                    : AppColors.crashTwentythColor,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 10),

                  hintStyle: Theme.of(context).textTheme.crashbodySmallPrimary
                      .copyWith(
                        color: enabled ? null : AppColors.crashFifthColor,
                      ),
                  filled: true,
                  fillColor: enabled
                      ? AppColors.crashSecondaryColor
                      : AppColors.crashSecondaryColor,
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
            ? AppColors.crashTwelfthColor
            : AppColors.crashTwelfthColor,
        //   padding: EdgeInsetsGeometry.all(24),
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
                ? AppColors.crashPrimaryColor
                : AppColors.crashTwentySecondColor,
          ),
        ),
      ),
    );
  }
}
