import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/game/crash/providers/crash_auto_cashout_provider.dart';
import 'package:wintek/features/game/crash/widgets/custom_slider.dart';

class CrashAutoPlaySettings {
  final int selectedRounds;
  final String betAmount;
  final double? autoCashout;

  CrashAutoPlaySettings({
    required this.selectedRounds,
    required this.betAmount,
    this.autoCashout,
  });
}

class CrashAutoPlay extends ConsumerStatefulWidget {
  final int index;
  final String initialBetAmount;

  const CrashAutoPlay({
    super.key,
    required this.index,
    required this.initialBetAmount,
  });

  @override
  ConsumerState<CrashAutoPlay> createState() => _CrashAutoPlayState();
}

class _CrashAutoPlayState extends ConsumerState<CrashAutoPlay> {
  int? selectedRounds;
  late TextEditingController _betAmountController;
  String? _roundsError;

  @override
  void initState() {
    super.initState();
    selectedRounds = 5;
    _betAmountController = TextEditingController(text: widget.initialBetAmount);
  }

  @override
  void dispose() {
    _betAmountController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    setState(() {
      _roundsError = null;
    });

    if (selectedRounds == null) {
      setState(() => _roundsError = 'Please, set number of rounds');
      return;
    }

    final autoCashout = ref.read(crashAutoCashoutProvider)[widget.index + 10];

    final settings = CrashAutoPlaySettings(
      selectedRounds: selectedRounds!,
      betAmount: _betAmountController.text,
      autoCashout: autoCashout,
    );

    Navigator.of(context).pop(settings);
  }

  void _increment(TextEditingController controller) {
    final currentValue = double.tryParse(controller.text) ?? 10.0;
    final newValue = (currentValue + 1.0).clamp(10.0, 1000.0);
    controller.text = newValue.toStringAsFixed(0);
  }

  void _decrement(TextEditingController controller) {
    final currentValue = double.tryParse(controller.text) ?? 10.0;
    final newValue = (currentValue - 1.0).clamp(10.0, 1000.0);
    controller.text = newValue.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: AlertDialog(
        backgroundColor: AppColors.crashTwentySeventhColor,
        contentPadding: const EdgeInsets.all(16),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height * 0.6, // 60% of screen
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
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
                          style: Theme.of(
                            context,
                          ).textTheme.crashBodyTitleSmall,
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

                  _buildAmountTextField(
                    context,
                    _betAmountController,
                    enabled: true,
                  ),
                  SizedBox(height: 30),
                  // Slider
                  CustomSlider(index: widget.index + 10),

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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _autoPlayButton(context, '5'),
                              const SizedBox(width: 8),

                              _autoPlayButton(context, '10'),
                              const SizedBox(width: 8),

                              _autoPlayButton(context, '25'),
                              const SizedBox(width: 8),

                              _autoPlayButton(context, '50'),
                              const SizedBox(width: 8),

                              _autoPlayButton(context, '100'),
                            ],
                          ),
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
                        style: Theme.of(
                          context,
                        ).textTheme.crashBodyMediumSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ((double.tryParse(_betAmountController.text) ?? 0) *
                                (selectedRounds ?? 0))
                            .toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.crashPrimaryColor,
                        ),
                      ),
                    ],
                  ),
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
                      height: 48,
                      elevation: 0,
                      borderRadius: 10,
                      width: double.infinity,
                      backgroundColor: AppColors.crashThirtyThreeColor,
                      onPressed: _startAutoPlay,
                      padding: EdgeInsets.only(
                        left: 23,
                        right: 23,
                        top: 4,
                        bottom: 4,
                      ),
                      child: Text(
                        'Place Bet',
                        style: Theme.of(context).textTheme.crashBodyMediumFifth,
                      ),
                    ),
                  ),
                ],
              ),
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
      borderColor: AppColors.crashThirtythColor,
      backgroundColor: AppColors.crashTwentyFirstColor,
      borderRadius: 50,
      height: 38,
      elevation: 0,
      isSelected: selectedRounds == int.parse(label),
      selectedBackgroundColor: AppColors.crashThirtySecondColor,
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
      height: 54,
      child: TextField(
        controller: controller,
        enabled: enabled,
        showCursor: true,
        cursorColor: AppColors.crashTwentyEigthColor,
        cursorHeight: 14,
        enableInteractiveSelection: false,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: Theme.of(context).textTheme.crashBodyTitleSmallThird,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          double? num = double.tryParse(value);
          if (num != null) {
            num = num.clamp(10.0, 1000.0);
            controller.text = num.toStringAsFixed(0);
            controller.selection = TextSelection.collapsed(
              offset: controller.text.length,
            );
          }
        },

        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero, // 🔥 FIXES VERTICAL ALIGNMENT
          filled: true,
          fillColor: AppColors.crashTwentyNinethColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(52),
            borderSide: BorderSide.none,
          ),

          prefix: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, child) {
                final double val = double.tryParse(value.text) ?? 10.0;
                final bool canDecrement = enabled && val > 10.0;
                return _buildIconButton(
                  Icons.remove,
                  () => _decrement(controller),
                  canDecrement,
                );
              },
            ),
          ),

          suffix: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, child) {
                final double val = double.tryParse(value.text) ?? 10.0;
                final bool canIncrement = enabled && val < 1000.0;
                return _buildIconButton(
                  Icons.add,
                  () => _increment(controller),
                  canIncrement,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
    IconData icon,
    VoidCallback onPressed,
    bool isEnabled,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: IgnorePointer(
        ignoring: !isEnabled,
        child: CustomElevatedButton(
          hasBorder: true,
          borderColor: AppColors.crashTwentyEigthColor,
          backgroundColor: AppColors.crashTwentyFirstColor,
          padding: EdgeInsets.zero,
          onPressed: isEnabled ? onPressed : () {},
          height: 18,
          width: 18,
          child: Center(
            child: Icon(
              icon,
              size: 18.33,
              color: isEnabled
                  ? AppColors.crashTwentyEigthColor
                  : AppColors.crashTwentyFirstColor,
            ),
          ),
        ),
      ),
    );
  }
}
