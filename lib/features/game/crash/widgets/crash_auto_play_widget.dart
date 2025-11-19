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
  // 0 means "no round selected yet" so no button is pre-selected
  int selectedRounds = 0;
  final _autoCashoutController = TextEditingController(text: '0.0');

  // Validation error messages
  String? _roundsError;
  String? _autoCashoutError;

  void _increment(TextEditingController controller) {
    int value = int.tryParse(controller.text) ?? 0;
    controller.text = (value + 1).toString();
  }

  void _decrement(TextEditingController controller) {
    int value = int.tryParse(controller.text) ?? 1;
    if (value > 1) {
      controller.text = (value - 1).toString();
    } else {
      controller.text = '1'; // clamp min
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: AlertDialog(
        backgroundColor: AppColors.crashTwentySeventhColor,
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          height: 432,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            //   spacing: 16,
            children: [
              Container(
                //  padding: EdgeInsets.all(8),
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
                    SizedBox(width: 24),
                    Text(
                      'Autoplay',
                      style: Theme.of(context).textTheme.crashBodyTitleSmall,
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
              SizedBox(height: 10),
              Text(
                'Bet Amount',
                style: Theme.of(context).textTheme.crashBodyMediumSecondary,
              ),
              SizedBox(height: 14),

              // Auto Cashout Multiplier
              _buildAmountTextField(
                context,
                _autoCashoutController,
                enabled: true,
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
              SizedBox(height: 30),
              // Slider
              CustomSlider(),

              SizedBox(height: 30),

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
                          'Number of rounds',
                          style: Theme.of(
                            context,
                          ).textTheme.crashBodyMediumSecondary,
                        ),
                        SizedBox(height: 14),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _autoPlayButton(context, '5'),
                        _autoPlayButton(context, '10'),
                        _autoPlayButton(context, '25'),
                        _autoPlayButton(context, '50'),
                        _autoPlayButton(context, '100'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Amount:',
                    style: Theme.of(context).textTheme.crashBodyMediumSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ((int.tryParse(_autoCashoutController.text) ?? 0) *
                            selectedRounds)
                        .toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.crashPrimaryColor,
                    ),
                  ),
                ],
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
                child: CustomElevatedButton(
                  height: 50,
                  elevation: 0,
                  borderRadius: 10,
                  width: double.infinity,
                  // hasBorder: true,
                  // borderColor: AppColors.crashFifteenthColor,
                  backgroundColor: AppColors.crashThirtyThreeColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.only(
                    left: 23,
                    right: 23,
                    top: 4,
                    bottom: 4,
                  ),
                  child: Text(
                    'Bet',
                    style: Theme.of(context).textTheme.crashBodyTitleMdeium,
                  ),
                ),
              ),
            ],
          ),
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
      borderColor: AppColors.crashThirtythColor,
      backgroundColor: AppColors.crashTwentyFirstColor,
      borderRadius: 50,
      height: 28,
      elevation: 0,
      isSelected: selectedRounds == int.parse(label),
      selectedBackgroundColor: AppColors.crashThirtySecondColor,
      child: Text(
        label,
        style: Theme.of(context).textTheme.crashBodyMediumPrimary,
      ),
    );
  }

  //!TextField for Amount Input
  Widget _buildAmountTextField(
    BuildContext context,
    TextEditingController controller, {
    bool enabled = true,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Center(
        child: Row(
          children: [
            // 🔹 TextField
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                showCursor: false,
                enableInteractiveSelection: false, // hides selection handle
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: Theme.of(context).textTheme.crashBodyTitleMdeium,
                cursorColor: AppColors.crashPrimaryColor,

                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 10),
                  hintStyle: Theme.of(context).textTheme.crashbodySmallPrimary,
                  filled: true,
                  fillColor: AppColors.crashTwentyNinethColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(52),
                    borderSide: BorderSide.none,
                  ),
                  prefix: // 🔹 Decrement button
                  _buildIconButton(
                    Icons.remove,
                    enabled ? () => _decrement(controller) : () {},
                    enabled: enabled,
                  ),

                  suffix: // 🔹 Increment button
                  _buildIconButton(
                    Icons.add,
                    enabled ? () => _increment(controller) : () {},
                    enabled: enabled,
                  ),
                ),
              ),
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
        hasBorder: true,
        borderColor: AppColors.crashTwentyEigthColor,
        backgroundColor: AppColors.crashTwentyFirstColor,
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
            color: AppColors.crashTwentyEigthColor,
          ),
        ),
      ),
    );
  }
}
