import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/aviator/widget/auto_play_widget.dart';
import 'package:wintek/features/game/crash/widgets/crash_auto_play_widget.dart';
import 'package:wintek/features/game/crash/widgets/crash_custom_bet_button.dart';
import 'package:wintek/features/game/crash/widgets/custom_slider.dart';

class CrashAutoPlaySettings {
  final AutoPlaySettings? settings;
  final int roundsPlayed;
  final double initialWallet;
  final double lastWinAmount;

  CrashAutoPlaySettings({
    this.settings,
    this.roundsPlayed = 0,
    this.initialWallet = 0.0,
    this.lastWinAmount = 0.0,
  });

  CrashAutoPlaySettings copyWith({
    AutoPlaySettings? settings,
    int? roundsPlayed,
    double? initialWallet,
    double? lastWinAmount,
  }) {
    return CrashAutoPlaySettings(
      settings: settings ?? this.settings,
      roundsPlayed: roundsPlayed ?? this.roundsPlayed,
      initialWallet: initialWallet ?? this.initialWallet,
      lastWinAmount: lastWinAmount ?? this.lastWinAmount,
    );
  }
}

class CrashBetContainer extends ConsumerStatefulWidget {
  final int index;
  final bool showAddButton;
  final VoidCallback? onAddPressed;
  //final bool showRemoveButton;
  final VoidCallback? onRemovePressed;

  const CrashBetContainer({
    super.key,
    required this.index,
    this.showAddButton = false,
    this.onAddPressed,
    //  this.showRemoveButton = false,
    this.onRemovePressed,
  });

  @override
  ConsumerState<CrashBetContainer> createState() => _CrashBetContainerState();
}

class _CrashBetContainerState extends ConsumerState<CrashBetContainer> {
  final _switchController = TextEditingController();
  final int _selectedValue = 0;
  final _amountController = TextEditingController();
  final _autoAmountController = TextEditingController();
  final secureStorageService = SecureStorageService();
  int selectedRounds = 10;

  Future<String?> getUserId() async {
    final creds = await secureStorageService.readCredentials();
    return creds.userId; // this will be null if nothing was saved
  }

  void _increment() {
    TextEditingController controller = _selectedValue == 0
        ? _amountController
        : _autoAmountController;
    int value = int.tryParse(controller.text) ?? 0;
    controller.text = (value + 1).toString();
  }

  void _decrement() {
    TextEditingController controller = _selectedValue == 0
        ? _amountController
        : _autoAmountController;
    int value = int.tryParse(controller.text) ?? 0;
    if (value > 0) {
      controller.text = (value - 1).toString();
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
      //height: 210,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.crashTwentySeventhColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.crashTwelfthColor, width: 1),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //   SizedBox(height: 16),
          //! AMOUNT TEXT FIELD  &  BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                //! Amount Text Field & Quick Amount Buttons
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAmountTextField(
                      context,
                      _amountController,
                      _decrement,
                      _increment,
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _autoPlayButton(context, '10'),
                          const SizedBox(width: 8),
                          _autoPlayButton(context, '20'),
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
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 90,
                  child: CrashCustomBetButton(
                    index: widget.index,
                    amountController: _amountController,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 2, child: CustomSlider()),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.crashThirtyFirstColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppColors.crashThirtySecondColor,
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CrashAutoPlay();
                        },
                      );
                    },
                    child: Text(
                      'Autoplay',
                      style: Theme.of(context).textTheme.crashBodyMediumPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _autoPlayButton(BuildContext context, String label) {
    return CustomElevatedButton(
      onPressed: () {
        setState(() {
          selectedRounds = int.parse(label);
          _amountController.text = label;
          // Clear rounds error when a round is selected
        });
      },
      width: 50,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      borderColor: AppColors.crashTwelfthColor,
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

  //!Auto BUTTON FOR AMOUNT
  Widget _buildAmountTextField(
    BuildContext context,
    TextEditingController controller,
    VoidCallback decrement,
    VoidCallback increment,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextField(
        showCursor: false,
        enableInteractiveSelection: false,
        controller: controller,
        cursorColor: AppColors.crashThirteenthColor,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.crashHeadlineSmall,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          filled: true,
          fillColor: AppColors.crashTwentyNinethColor,
          hintStyle: Theme.of(context).textTheme.crashHeadlineSmall,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: AppColors.crashThirtythColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: AppColors.crashThirtythColor,
              width: 2,
            ),
          ),

          suffixIconConstraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),

          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                type: MaterialType.transparency,
                child: IconButton(
                  splashRadius: 18,
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    size: 30,
                    color: AppColors.crashTwentyEigthColor,
                  ),
                  onPressed: () {
                    final value =
                        int.tryParse(
                          controller.text.isEmpty ? '1' : controller.text,
                        ) ??
                        1;
                    if (value > 1) {
                      controller.text = (value - 1).toString();
                    } else {
                      controller.text = '1';
                    }
                  },
                  tooltip: 'Decrement',
                ),
              ),

              // INCREMENT button
              Material(
                type: MaterialType.transparency,
                child: IconButton(
                  splashRadius: 18,
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 30,
                    color: AppColors.crashTwentyEigthColor,
                  ),
                  onPressed: () {
                    int value = int.tryParse(controller.text) ?? 0;
                    controller.text = (value + 1).toString();
                  },
                  tooltip: 'Increment',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _autoAmountController.dispose();
    _switchController.dispose();
    super.dispose();
  }
}
