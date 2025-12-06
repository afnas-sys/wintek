import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/aviator/widget/auto_play_widget.dart';
import 'package:wintek/features/game/aviator/providers/user_provider.dart';
import 'package:wintek/features/game/crash/widgets/crash_auto_play_widget.dart';
import 'package:wintek/features/game/crash/widgets/crash_custom_bet_button.dart';
import 'package:wintek/features/game/crash/widgets/custom_slider.dart';
import 'package:wintek/features/game/crash/service/crash_bet_cache_service.dart';

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
  final _cacheService = CrashBetCacheService();
  int selectedRounds = 10;
  AutoPlayState? autoPlaySettings;
  bool hasPlacedManualBet = false;

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

  void _onAutoPlayUpdate(int rounds, double winAmount) {
    setState(() {
      autoPlaySettings = autoPlaySettings?.copyWith(
        roundsPlayed: rounds,
        lastWinAmount: winAmount,
      );
    });
    if (autoPlaySettings != null) {
      _saveAutoPlayState();
    }
  }

  void _onAutoPlayStop() {
    setState(() {
      autoPlaySettings = null;
    });
    _cacheService.clearAutoPlayState(widget.index);
  }

  void _onManualBetPlaced(bool placed) {
    setState(() {
      hasPlacedManualBet = placed;
    });
  }

  bool _shouldContinueAutoPlay(double currentWallet, double lastWinAmount) {
    final settings = autoPlaySettings?.settings;
    if (settings == null) return false;
    if (autoPlaySettings!.roundsPlayed >= int.parse(settings.selectedRounds!)) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    _amountController.text = 10.toString();
    _autoAmountController.text = 1.toString();

    super.initState();
    _restoreAutoPlayState();
  }

  Future<void> _restoreAutoPlayState() async {
    final cachedState = await _cacheService.getAutoPlayState(widget.index);
    if (cachedState != null) {
      if (!mounted) return;
      setState(() {
        autoPlaySettings = AutoPlayState(
          settings: AutoPlaySettings(
            selectedRounds: cachedState['selectedRounds'],
            stopIfCashDecreases: cachedState['stopIfCashDecreases'] ?? false,
            decrementAmount: cachedState['decrementAmount'] ?? 0.0,
            stopIfCashIncreases: cachedState['stopIfCashIncreases'] ?? false,
            incrementAmount: cachedState['incrementAmount'] ?? 0.0,
            stopIfSingleWinExceeds:
                cachedState['stopIfSingleWinExceeds'] ?? false,
            exceedsAmount: cachedState['exceedsAmount'] ?? 0.0,
            autoCashout: cachedState['autoCashout'],
          ),
          roundsPlayed: cachedState['roundsPlayed'] ?? 0,
          initialWallet: cachedState['initialWallet'] ?? 0.0,
          lastWinAmount: cachedState['lastWinAmount'] ?? 0.0,
        );
        // Restore bet amount if available
        if (cachedState['betAmount'] != null) {
          _amountController.text = cachedState['betAmount'];
        }
      });
    }
  }

  Future<void> _saveAutoPlayState() async {
    if (autoPlaySettings == null || autoPlaySettings!.settings == null) return;
    final settings = autoPlaySettings!.settings!;
    final state = {
      'selectedRounds': settings.selectedRounds,
      'stopIfCashDecreases': settings.stopIfCashDecreases,
      'decrementAmount': settings.decrementAmount,
      'stopIfCashIncreases': settings.stopIfCashIncreases,
      'incrementAmount': settings.incrementAmount,
      'stopIfSingleWinExceeds': settings.stopIfSingleWinExceeds,
      'exceedsAmount': settings.exceedsAmount,
      'autoCashout': settings.autoCashout,
      'roundsPlayed': autoPlaySettings!.roundsPlayed,
      'initialWallet': autoPlaySettings!.initialWallet,
      'lastWinAmount': autoPlaySettings!.lastWinAmount,
      'betAmount': _amountController.text,
    };
    await _cacheService.saveAutoPlayState(widget.index, state);
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
                      !hasPlacedManualBet,
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _quickPlayButton(context, '10', !hasPlacedManualBet),
                          const SizedBox(width: 8),
                          _quickPlayButton(context, '20', !hasPlacedManualBet),
                          const SizedBox(width: 8),
                          _quickPlayButton(context, '50', !hasPlacedManualBet),
                          const SizedBox(width: 8),
                          _quickPlayButton(context, '100', !hasPlacedManualBet),
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
                    autoPlayState: autoPlaySettings,
                    onAutoPlayUpdate: _onAutoPlayUpdate,
                    onAutoPlayStop: _onAutoPlayStop,
                    shouldContinueAutoPlay: _shouldContinueAutoPlay,
                    onManualBetPlaced: _onManualBetPlaced,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: CustomSlider(
                  index: widget.index,
                  disabled: hasPlacedManualBet,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 42,
                  child: _buildAutoplayButton(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickPlayButton(BuildContext context, String label, bool enabled) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: CustomElevatedButton(
        onPressed: enabled
            ? () {
                setState(() {
                  selectedRounds = int.parse(label);
                  _amountController.text = label;
                  // Clear rounds error when a round is selected
                });
              }
            : null,
        width: 50,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        borderColor: AppColors.crashTwelfthColor,
        backgroundColor: AppColors.crashTwentyFirstColor,
        borderRadius: 50,
        height: 24,
        elevation: 0,
        isSelected: selectedRounds == int.parse(label),
        selectedBackgroundColor: AppColors.crashThirtySecondColor,
        child: Text(
          label,
          style: Theme.of(context).textTheme.crashbodySmallThird,
        ),
      ),
    );
  }

  //!Auto BUTTON FOR AMOUNT
  Widget _buildAmountTextField(
    BuildContext context,
    TextEditingController controller,
    VoidCallback decrement,
    VoidCallback increment,
    bool enabled,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: TextField(
        showCursor: true,
        cursorColor: AppColors.crashTwentyEigthColor,
        cursorHeight: 14,
        enableInteractiveSelection: false,
        enabled: enabled,
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.crashBodyMediumFifth,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          int? num = int.tryParse(value);
          if (num != null) {
            num = num.clamp(10, 1000);
            controller.text = num.toString();
            controller.selection = TextSelection.collapsed(
              offset: controller.text.length,
            );
          }
        },
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

          // suffixIconConstraints: const BoxConstraints(
          //   minWidth: 32,
          //   minHeight: 32,
          // ),
          suffixIcon: ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              final int val = int.tryParse(value.text) ?? 10;
              final bool canDecrement = enabled && val > 10;
              final bool canIncrement = enabled && val < 1000;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: IgnorePointer(
                      ignoring: !canDecrement,
                      child: GestureDetector(
                        onTap: () {
                          final currentVal =
                              int.tryParse(controller.text) ?? 10;
                          controller.text =
                              (currentVal > 10 ? currentVal - 1 : 10)
                                  .toString();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.crashTwentyEigthColor,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.remove,
                            size: 16,
                            color: canDecrement
                                ? AppColors.crashTwentyEigthColor
                                : Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  SizedBox(
                    width: 22,
                    height: 22,
                    child: IgnorePointer(
                      ignoring: !canIncrement,
                      child: GestureDetector(
                        onTap: () {
                          int currentVal = int.tryParse(controller.text) ?? 10;
                          controller.text = min(
                            currentVal + 1,
                            1000,
                          ).toString();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.crashTwentyEigthColor,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.add,
                            size: 16,
                            color: canIncrement
                                ? AppColors.crashTwentyEigthColor
                                : Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAutoplayButton(BuildContext context) {
    final isAutoPlayActive = autoPlaySettings != null;
    final maxRounds = autoPlaySettings?.settings?.selectedRounds != null
        ? int.tryParse(autoPlaySettings!.settings!.selectedRounds!) ?? 0
        : 0;
    final currentRound = autoPlaySettings?.roundsPlayed ?? 0;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isAutoPlayActive
            ? AppColors.crashTwentyFourthColor
            : AppColors.crashThirtyFirstColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isAutoPlayActive
                ? AppColors.crashTwentyFourthColor
                : AppColors.crashThirtySecondColor,
            width: 1,
          ),
        ),
      ),
      onPressed: hasPlacedManualBet
          ? null
          : () async {
              if (isAutoPlayActive) {
                _onAutoPlayStop();
              } else {
                final result = await showDialog<CrashAutoPlaySettings>(
                  context: context,
                  builder: (BuildContext context) {
                    return CrashAutoPlay(
                      index: widget.index,
                      initialBetAmount: _amountController.text,
                    );
                  },
                );
                if (result != null) {
                  // Update bet amount from autoplay settings
                  _amountController.text = result.betAmount;

                  final user = ref.read(userProvider);
                  user.maybeWhen(
                    data: (userModel) {
                      if (userModel != null) {
                        setState(() {
                          autoPlaySettings = AutoPlayState(
                            settings: AutoPlaySettings(
                              selectedRounds: result.selectedRounds.toString(),
                              stopIfCashDecreases: false,
                              decrementAmount: 0.0,
                              stopIfCashIncreases: false,
                              incrementAmount: 0.0,
                              stopIfSingleWinExceeds: false,
                              exceedsAmount: 0.0,
                              autoCashout: result.autoCashout,
                            ),
                            initialWallet: userModel.data.wallet,
                          );
                        });
                        _saveAutoPlayState();
                      }
                    },
                    orElse: () {},
                  );
                }
              }
            },
      child: Text(
        isAutoPlayActive
            ? 'STOP ($currentRound/${maxRounds > 0 ? maxRounds : '∞'})'
            : 'Autoplay',
        style: Theme.of(context).textTheme.crashbodySmallThird,
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
