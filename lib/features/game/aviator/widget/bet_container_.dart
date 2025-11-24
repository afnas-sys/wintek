import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/aviator/providers/user_provider.dart';
import 'package:wintek/features/game/aviator/widget/auto_play_widget.dart';

import 'package:wintek/features/game/aviator/widget/custom_bet_button%20.dart';

class AutoPlayState {
  final AutoPlaySettings? settings;
  final int roundsPlayed;
  final double initialWallet;
  final double lastWinAmount;

  AutoPlayState({
    this.settings,
    this.roundsPlayed = 0,
    this.initialWallet = 0.0,
    this.lastWinAmount = 0.0,
  });

  AutoPlayState copyWith({
    AutoPlaySettings? settings,
    int? roundsPlayed,
    double? initialWallet,
    double? lastWinAmount,
  }) {
    return AutoPlayState(
      settings: settings ?? this.settings,
      roundsPlayed: roundsPlayed ?? this.roundsPlayed,
      initialWallet: initialWallet ?? this.initialWallet,
      lastWinAmount: lastWinAmount ?? this.lastWinAmount,
    );
  }
}

class BetContainer extends ConsumerStatefulWidget {
  final int index;
  final bool showAddButton;
  final VoidCallback? onAddPressed;
  final bool showRemoveButton;
  final VoidCallback? onRemovePressed;

  const BetContainer({
    super.key,
    required this.index,
    this.showAddButton = false,
    this.onAddPressed,
    this.showRemoveButton = false,
    this.onRemovePressed,
  });

  @override
  ConsumerState<BetContainer> createState() => _BetContainerState();
}

class _BetContainerState extends ConsumerState<BetContainer> {
  final _switchController = TextEditingController();
  int _selectedValue = 0;
  bool _isSwitched = false;
  final _amountController = TextEditingController();
  final _autoAmountController = TextEditingController();
  final secureStorageService = SecureStorageService();

  AutoPlayState _autoPlayState = AutoPlayState();

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

  void _startAutoPlay(AutoPlaySettings settings) {
    final user = ref.read(userProvider);
    user.maybeWhen(
      data: (userModel) {
        if (userModel != null) {
          setState(() {
            _autoPlayState = AutoPlayState(
              settings: settings,
              roundsPlayed: 0,
              initialWallet: userModel.data.wallet,
              lastWinAmount: 0.0,
            );
          });
          // Place the first bet immediately
          _placeFirstAutoBet();
        }
      },
      orElse: () {},
    );
  }

  void _placeFirstAutoBet() {
    // Trigger the first bet placement for autoplay
    // This will be handled by the CustomBetButton's autoplay logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // The CustomBetButton will handle placing the first bet when autoplay starts
    });
  }

  void _stopAutoPlay() {
    setState(() {
      _autoPlayState = AutoPlayState();
    });
  }

  bool _shouldContinueAutoPlay(double currentWallet, double winAmount) {
    if (_autoPlayState.settings == null) return false;

    final settings = _autoPlayState.settings!;
    final roundsPlayed = _autoPlayState.roundsPlayed;
    final maxRounds = int.tryParse(settings.selectedRounds ?? '0') ?? 0;

    // Check if max rounds reached
    if (maxRounds > 0 && roundsPlayed >= maxRounds) return false;

    // Check cash decrease condition
    if (settings.stopIfCashDecreases) {
      final decrease = _autoPlayState.initialWallet - currentWallet;
      if (decrease >= settings.decrementAmount) return false;
    }

    // Check cash increase condition
    if (settings.stopIfCashIncreases) {
      final increase = currentWallet - _autoPlayState.initialWallet;
      if (increase >= settings.incrementAmount) return false;
    }

    // Check single win exceeds condition
    if (settings.stopIfSingleWinExceeds &&
        winAmount >= settings.exceedsAmount) {
      return false;
    }

    return true;
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
    _switchController.text = 1.5.toString();
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
        color: AppColors.aviatorTwentiethColor,
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
              if (widget.showRemoveButton)
                CustomElevatedButton(
                  hasBorder: true,
                  borderColor: AppColors.aviatorFourtyColor,
                  backgroundColor: AppColors.aviatorTwentiethColor,
                  padding: EdgeInsetsGeometry.all(2),
                  height: 22,
                  width: 22,
                  onPressed: widget.onRemovePressed,
                  child: Icon(
                    Icons.remove,
                    size: 18.33,
                    color: AppColors.aviatorFourtyColor,
                  ),
                )
              else if (widget.showAddButton)
                CustomElevatedButton(
                  hasBorder: true,
                  borderColor: AppColors.aviatorFourtyColor,
                  backgroundColor: AppColors.aviatorTwentiethColor,
                  padding: EdgeInsetsGeometry.all(2),
                  height: 22,
                  width: 22,
                  onPressed: widget.onAddPressed,
                  child: Icon(
                    Icons.add,
                    size: 18.33,
                    color: AppColors.aviatorFourtyColor,
                  ),
                )
              else
                SizedBox(width: 22, height: 22),
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
        color: AppColors.aviatorTwentiethColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.aviatorFifteenthColor, width: 1),
      ),

      thumbDecoration: BoxDecoration(
        color: AppColors.aviatorFifteenthColor,
        borderRadius: BorderRadius.circular(30),
      ),

      // ⭐ CONTROL SHAPE & EFFECT HERE ⭐
      customSegmentSettings: CustomSegmentSettings(
        borderRadius: BorderRadius.circular(30), // shape of ripple
        splashColor: Colors.transparent, // remove ripple color
        highlightColor: Colors.transparent, // remove highlight
        overlayColor: MaterialStateProperty.all(Colors.transparent),
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
        enableInteractiveSelection: false,
        controller: controller,
        cursorColor: AppColors.aviatorSixteenthColor,
        cursorHeight: 20,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.aviatorHeadlineSmall,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 8,
          ),
          // hintText: "1.00",
          hintStyle: Theme.of(context).textTheme.aviatorHeadlineSmallSecond,
          filled: true,
          fillColor: AppColors.aviatorTwentiethColor,
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
      backgroundColor: AppColors.aviatorFifteenthColor,
      padding: const EdgeInsets.all(2),
      height: 22,
      width: 22,
      onPressed: onPressed,
      child: Icon(icon, size: 18.33, color: AppColors.aviatorTertiaryColor),
    );
  }

  //!Quick Amount Button
  Widget _quickAmountButton(BuildContext context, String label, String value) {
    return CustomElevatedButton(
      onPressed: () => _setAmount(value),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      borderColor: Color(0XFFAA99FD).withOpacity(.2),
      backgroundColor: Color(0XFF222222).withOpacity(.04),
      borderRadius: 30,
      height: 28,
      elevation: 0,
      child: Text(
        label,
        style: Theme.of(context).textTheme.aviatorBodyMediumFifth,
      ),
    );
  }

  //!AUTOPLAY
  Widget _buildAutoplayButton(BuildContext context) {
    final isAutoPlayActive = _autoPlayState.settings != null;
    final maxRounds = _autoPlayState.settings?.selectedRounds != null
        ? int.tryParse(_autoPlayState.settings!.selectedRounds!) ?? 0
        : 0;
    final currentRound = _autoPlayState.roundsPlayed;

    return Flexible(
      flex: 2,
      child: CustomElevatedButton(
        onPressed: () async {
          if (isAutoPlayActive) {
            // Stop autoplay
            _stopAutoPlay();
          } else {
            // Start autoplay - show dialog with callback
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AutoPlayWidget(
                  onStart: (settings) {
                    _startAutoPlay(settings);
                  },
                );
              },
            );
          }
        },
        padding: const EdgeInsets.symmetric(horizontal: 12),
        borderRadius: 52,
        backgroundColor: isAutoPlayActive
            ? AppColors
                  .aviatorSeventeenthColor // Red color for stop
            : AppColors.aviatorTwentyNinthColor,
        hasBorder: true,
        height: 28,
        borderColor: isAutoPlayActive
            ? AppColors.aviatorEighteenthColor
            : AppColors.aviatorNineteenthColor,
        child: Text(
          isAutoPlayActive
              ? 'STOP ($currentRound/${maxRounds > 0 ? maxRounds : '∞'})'
              : 'AUTOPLAY',
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
              style: Theme.of(context).textTheme.aviatorbodySmallPrimary,
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
                enableInteractiveSelection: false,
                enabled: _isSwitched,
                controller: _switchController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.aviatorBodyMediumPrimary,
                decoration: InputDecoration(
                  suffixText: "x",
                  suffixStyle: TextStyle(
                    color: AppColors.aviatorSixteenthColor,
                  ),
                  // hintText: "1.5",
                  // hintStyle: Theme.of(
                  //   context,
                  // ).textTheme.aviatorBodyMediumFourth,
                  filled: true,
                  fillColor: AppColors.aviatorFifteenthColor,
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
      autoPlayState: _autoPlayState,
      onAutoPlayUpdate: (roundsPlayed, lastWinAmount) {
        setState(() {
          _autoPlayState = _autoPlayState.copyWith(
            roundsPlayed: roundsPlayed,
            lastWinAmount: lastWinAmount,
          );
        });
      },
      onAutoPlayStop: _stopAutoPlay,
      shouldContinueAutoPlay: _shouldContinueAutoPlay,
    );
  }
}
