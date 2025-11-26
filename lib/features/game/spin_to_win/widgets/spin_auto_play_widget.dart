import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';

class SpinToWinAutoPlayWidget {
  final int selectedRounds;
  final double autoCashoutMultiplier;

  SpinToWinAutoPlayWidget({
    required this.selectedRounds,
    required this.autoCashoutMultiplier,
  });
}

class SpinToWinAutoPlay extends StatefulWidget {
  final Function(SpinToWinAutoPlayWidget)? onStart;

  const SpinToWinAutoPlay({super.key, this.onStart});

  @override
  State<SpinToWinAutoPlay> createState() => _SpinToWinAutoPlayState();
}

class _SpinToWinAutoPlayState extends State<SpinToWinAutoPlay> {
  int selectedRounds = 0;
  final _autoCashoutController = TextEditingController(text: '0.0');

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
      controller.text = '1';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: AlertDialog(
        backgroundColor: AppColors.spinToWinEleventhColor,
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          height: 351,
          width: double.maxFinite,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.spinToWinTenthColor,
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
                        style: Theme.of(
                          context,
                        ).textTheme.spinBodyTitleSmallSecondary,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          color: AppColors.spinToWinSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Bet Amount',
                  style: Theme.of(context).textTheme.spinBodyMediumFifth,
                ),
                SizedBox(height: 14),

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
                        color: AppColors.spinToWinThirteenthColor,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                SizedBox(height: 30),

                // Rounds
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.spinToWinTenthColor,
                    borderRadius: BorderRadius.circular(20),
                    border: _roundsError != null
                        ? Border.all(
                            color: AppColors.spinToWinFourteenthColor,
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
                            ).textTheme.spinBodyMediumFifth,
                          ),
                          SizedBox(height: 14),
                          if (_roundsError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                _roundsError!,
                                style: const TextStyle(
                                  color: AppColors.spinToWinThirteenthColor,
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
                      style: Theme.of(context).textTheme.spinBodyMediumFifth,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ((int.tryParse(_autoCashoutController.text) ?? 0) *
                              selectedRounds)
                          .toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.spinToWinSecondaryColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.spinToWinTenthColor,
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
                    backgroundColor: AppColors.spinToWinFifteenthColor,
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
                      'Spin Now',
                      style: Theme.of(context).textTheme.spinBodyTitleMdeium,
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

  Widget _autoPlayButton(BuildContext context, String label) {
    return CustomElevatedButton(
      onPressed: () {
        setState(() {
          selectedRounds = int.parse(label);
          _roundsError = null;
        });
      },
      width: 50,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      borderColor: AppColors.spinSixthColor,
      backgroundColor: AppColors.spinToWinTenthColor,
      borderRadius: 50,
      height: 28,
      elevation: 0,
      isSelected: selectedRounds == int.parse(label),
      selectedBackgroundColor: AppColors.spinToWinSeventhColor,
      child: Text(
        label,
        style: Theme.of(context).textTheme.spinBodyMediumPrimary,
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
      child: TextField(
        controller: controller,
        enabled: enabled,
        showCursor: true,
        cursorColor: AppColors.spinToWinFourthColor,
        cursorHeight: 14,
        enableInteractiveSelection: false,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: Theme.of(context).textTheme.spinBodyTitleMdeium,

        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 10),
          hintStyle: Theme.of(context).textTheme.spinbodySmallPrimary,
          filled: true,
          fillColor: AppColors.spinToWinFifthColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(52),
            borderSide: BorderSide.none,
          ),
          prefix: // 🔹 Decrement button
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: _buildIconButton(
              Icons.remove,
              enabled ? () => _decrement(controller) : () {},
              enabled: enabled,
            ),
          ),

          suffix: // 🔹 Increment button
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildIconButton(
              Icons.add,
              enabled ? () => _increment(controller) : () {},
              enabled: enabled,
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
        hasBorder: true,
        borderColor: AppColors.spinToWinFourthColor,
        backgroundColor: AppColors.spinToWinTenthColor,
        padding: EdgeInsetsGeometry.only(left: 0, right: 0, top: 0, bottom: 0),
        onPressed: onPressed,
        height: 22,
        width: 22,
        borderRadius: 100,
        child: Center(
          child: Icon(icon, size: 18.33, color: AppColors.spinToWinFourthColor),
        ),
      ),
    );
  }
}
