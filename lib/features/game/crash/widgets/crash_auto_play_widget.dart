import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/game/crash/widgets/custom_slider.dart';

class CrashAutoPlayWidget {
  final int selectedRounds;
  final double autoCashoutMultiplier;

  CrashAutoPlayWidget({
    required this.selectedRounds,
    required this.autoCashoutMultiplier,
  });
}

class CrashAutoPlay extends StatefulWidget {
  final Function(CrashAutoPlayWidget)? onStart;

  const CrashAutoPlay({super.key, this.onStart});

  @override
  State<CrashAutoPlay> createState() => _CrashAutoPlayState();
}

class _CrashAutoPlayState extends State<CrashAutoPlay> {
  int selectedRounds = 10;
  final _autoCashoutController = TextEditingController(text: '1.0');

  // Validation error messages
  String? _roundsError;
  String? _autoCashoutError;
  bool _isUpdatingAmount = false;

  // void _startAutoPlay() {
  //   // Clear previous errors
  //   setState(() {
  //     _roundsError = null;
  //     _autoCashoutError = null;
  //   });

  //   bool hasErrors = false;

  //   // Validation: Check if auto cashout multiplier is valid
  //   final autoCashoutValue =
  //       double.tryParse(_autoCashoutController.text) ?? 0.0;
  //   if (autoCashoutValue <= 1.0) {
  //     setState(
  //       () => _autoCashoutError = 'Auto cashout must be greater than 1.0x',
  //     );
  //     hasErrors = true;
  //   }

  //   if (hasErrors) return;

  //   final settings = CrashAutoPlayWidget(
  //     selectedRounds: selectedRounds,
  //     autoCashoutMultiplier: autoCashoutValue,
  //   );

  //   // Call the callback if provided, otherwise pop with settings
  //   if (widget.onStart != null) {
  //     widget.onStart!(settings);
  //     Navigator.of(context).pop();
  //   } else {
  //     Navigator.of(context).pop(settings);
  //   }
  // }

  void _increment(TextEditingController controller) {
    int value = int.tryParse(controller.text) ?? 1;
    if (value < 100) {
      controller.text = (value + 1).toString();
    } else {
      controller.text = '100'; // clamp max
    }
  }

  void _decrement(TextEditingController controller) {
    int value = int.tryParse(controller.text) ?? 1;
    if (value > 1) {
      controller.text = (value - 1).toString();
    } else {
      controller.text = '1'; // clamp min
    }
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
          height: 350,
          width: double.maxFinite,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.crashEleventhColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              spacing: 16,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.crashTwentyFirstColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Text(
                        'Autoplay',
                        style: Theme.of(context).textTheme.crashBodyTitleMdeium,
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

                // Auto Cashout Multiplier
                Container(
                  //  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.crashTwentyFirstColor,
                    //   borderRadius: BorderRadius.circular(0),
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
                            child: _buildAmountTextField(
                              context,
                              _autoCashoutController,
                              enabled: true,
                            ),
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

                // Slider
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomSlider(),
                ),

                // Rounds
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.crashTwentyFirstColor,
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
                          SizedBox(height: 4),
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
                          _autoPlayButton(context, '100'),
                        ],
                      ),
                    ],
                  ),
                ),

                //  SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.crashTwentyFirstColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0XFF3acd9f), Color(0XFF1b9f31)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomElevatedButton(
                        height: 50,
                        elevation: 0,
                        borderRadius: 10,
                        width: double.infinity,
                        // hasBorder: true,
                        // borderColor: AppColors.crashFifteenthColor,
                        backgroundColor: Colors.transparent,
                        onPressed: _resetAll,
                        padding: EdgeInsets.only(
                          left: 23,
                          right: 23,
                          top: 4,
                          bottom: 4,
                        ),
                        child: Text(
                          'Start Autoplay',
                          style: Theme.of(
                            context,
                          ).textTheme.crashBodyTitleMdeium,
                        ),
                      ),
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
      width: double.infinity,
      height: 36,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.crashSecondaryColor,
          //  borderRadius: BorderRadius.circular(52),
        ),
        child: Center(
          child: Row(
            children: [
              // 🔹 MIN button
              _buildTextButton(
                label: "MIN",
                enabled: enabled,
                onTap: () {
                  if (!enabled) return;
                  controller.text = '1';
                },
              ),

              // 🔹 Decrement button
              _buildIconButton(
                Icons.remove,
                enabled ? () => _decrement(controller) : () {},
                enabled: enabled,
              ),

              // 🔹 Center TextField
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  showCursor: true,
                  enableInteractiveSelection: false, // hides selection handle
                  cursorHeight: 12,
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: Theme.of(context).textTheme.crashBodyTitleMdeium
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
                    fillColor: AppColors.crashSecondaryColor,
                    border: InputBorder.none,
                  ),

                  // ✅ Restrict input between 1–100
                  onChanged: (value) {
                    if (_isUpdatingAmount) return;
                    _isUpdatingAmount = true;

                    final numValue = double.tryParse(value) ?? 1;

                    if (numValue > 100) {
                      controller.text = '100';
                    } else if (numValue < 1) {
                      controller.text = '1';
                    }

                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );

                    _isUpdatingAmount = false;
                  },
                ),
              ),

              // 🔹 Increment button
              _buildIconButton(
                Icons.add,
                enabled ? () => _increment(controller) : () {},
                enabled: enabled,
              ),

              // 🔹 MAX button
              _buildTextButton(
                label: "MAX",
                enabled: enabled,
                onTap: () {
                  if (!enabled) return;
                  controller.text = '100';
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper for MIN / MAX buttons
  Widget _buildTextButton({
    required String label,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.crashPrimaryColor.withOpacity(0.1)
                : Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: enabled
                  ? AppColors.crashPrimaryColor
                  : AppColors.crashFifthColor,
            ),
          ),
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
