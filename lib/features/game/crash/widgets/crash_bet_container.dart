import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/game/aviator/widget/auto_play_widget.dart';
import 'package:wintek/features/game/crash/widgets/crash_auto_play_widget.dart';
import 'package:wintek/features/game/crash/widgets/crash_custom_bet_button.dart';

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
  final bool showRemoveButton;
  final VoidCallback? onRemovePressed;

  const CrashBetContainer({
    super.key,
    required this.index,
    this.showAddButton = false,
    this.onAddPressed,
    this.showRemoveButton = false,
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
  bool _isUpdatingAmount = false;

  Future<String?> getUserId() async {
    final creds = await secureStorageService.readCredentials();
    return creds.userId; // this will be null if nothing was saved
  }

  // void _setAmount(String value) {
  //   setState(() {
  //     TextEditingController controller = _selectedValue == 0
  //         ? _amountController
  //         : _autoAmountController;
  //     int newValue = int.tryParse(value) ?? 0;
  //     if (newValue > 100) newValue = 100;
  //     if (newValue < 0) newValue = 0;
  //     controller.text = newValue.toString();
  //   });
  // }

  void _increment() {
    TextEditingController controller = _selectedValue == 0
        ? _amountController
        : _autoAmountController;
    int value = int.tryParse(controller.text) ?? 0;
    if (value < 100) {
      controller.text = (value + 1).toString();
    }
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
    _amountController.addListener(_enforceMaxValue);
    _autoAmountController.addListener(_enforceMaxValue);
    super.initState();
  }

  void _enforceMaxValue() {
    if (_isUpdatingAmount) return;
    _isUpdatingAmount = true;
    TextEditingController controller = _selectedValue == 0
        ? _amountController
        : _autoAmountController;
    final numValue = double.tryParse(controller.text) ?? 0;
    if (numValue > 100) {
      controller.text = '100';
    } else if (numValue < 0) {
      controller.text = '0';
    }
    _isUpdatingAmount = false;
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
        color: AppColors.crashEleventhColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.crashTwelfthColor, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: SizedBox(width: 0, height: 0)),

              if (widget.showRemoveButton)
                CustomElevatedButton(
                  hasBorder: true,
                  borderColor: AppColors.crashTwelfthColor,
                  backgroundColor: AppColors.crashEleventhColor,
                  padding: EdgeInsetsGeometry.all(2),
                  height: 22,
                  width: 22,
                  onPressed: widget.onRemovePressed,
                  child: Icon(
                    Icons.remove,
                    size: 18.33,
                    color: AppColors.crashTwelfthColor,
                  ),
                )
              else if (widget.showAddButton)
                CustomElevatedButton(
                  hasBorder: true,
                  borderColor: AppColors.crashTwelfthColor,
                  backgroundColor: AppColors.crashEleventhColor,
                  padding: EdgeInsetsGeometry.all(2),
                  height: 22,
                  width: 22,
                  onPressed: widget.onAddPressed,
                  child: Icon(
                    Icons.add,
                    size: 18.33,
                    color: AppColors.crashTwelfthColor,
                  ),
                )
              else
                SizedBox(width: 22, height: 22),
            ],
          ),
          // const SizedBox(height: 20),
          Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 16),
                _buildAmountTextField(
                  context,
                  _amountController,
                  _decrement,
                  _increment,
                ),
                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.crashTwentySixthColor,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CrashAutoPlay();
                            },
                          );
                        },
                        child: Center(
                          child: Image.asset(
                            AppImages.refresh,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: CrashCustomBetButton(
                          index: widget.index,
                          amountController: _amountController,
                        ),
                      ),
                    ),
                  ],
                ),
                // Expanded(
                //   flex: 1,
                //   child: Row(
                //     children: [
                //       Column(
                //         children: [
                //           //! container for Amount, + & - button
                //           _buildAmountTextField(
                //             context,
                //             _amountController,
                //             _decrement,
                //             _increment,
                //           ),

                //           SizedBox(height: 10),
                //           //! BUTTON FOR ₹10 & ₹20
                //           Row(
                //             children: [
                //               _quickAmountButton(context, 'Min', '1'),
                //               const SizedBox(width: 6),
                //               _quickAmountButton(context, 'Max', '100'),
                //             ],
                //           ),

                //           //! BUTTON FOR ₹50 & ₹100
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                //  SizedBox(width: 20),
                //! Manual BUTTON FOR BET
                // Expanded(child: _manualBetButton()),
              ],
            ),
            //!      ----------------------  AUTO---------------------------------
            //  Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       SizedBox(height: 16),
            //       Expanded(
            //         child: Row(
            //           children: [
            //             Column(
            //               children: [
            //                 //! CONTAINER FOR AMOUNT, + & - button in AUTo
            //                 _buildAmountTextField(
            //                   context,
            //                   _autoAmountController,
            //                   _decrement,
            //                   _increment,
            //                 ),

            //                 SizedBox(height: 10),
            //                 //!Auto BUTTON FOR AMOUNT 10 & 20
            //                 Row(
            //                   children: [
            //                     _quickAmountButton(context, 'Min', '1'),
            //                     const SizedBox(width: 6),
            //                     _quickAmountButton(context, 'Max', '100'),
            //                   ],
            //                 ),

            //                 //!Auto BUTTON FOR AMOUNT 50 &100
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //       //  SizedBox(width: 20),
            //       //!Auto BUTTON FOR BET---------------------------------------------------
            //       Expanded(
            //         flex: 1,
            //         child: Stack(
            //           alignment: Alignment.center,
            //           children: [
            //             // ConstrainedBox makes sure the child can expand but not force infinite
            //             ConstrainedBox(
            //               constraints: const BoxConstraints(
            //                 minWidth: 0,
            //                 maxWidth: double.infinity,
            //               ),
            //               child: SizedBox(
            //                 width: double
            //                     .infinity, // now safe because Expanded gives bounded width
            //                 child:
            //                     _manualBetButton(), // make sure this widget can accept full width
            //               ),
            //             ),

            //             // Overlay label (centered — change to Positioned if you want top-right)
            //             Positioned(
            //               top: -1,
            //               right: -2,
            //               child: Container(
            //                 width: 38,
            //                 height: 38,
            //                 decoration: BoxDecoration(
            //                   border: Border.all(
            //                     color: AppColors.crashEleventhColor,
            //                     width: 5,
            //                   ),
            //                   shape: BoxShape.circle,
            //                   color: AppColors.crashTwelfthColor,
            //                 ),
            //                 child: GestureDetector(
            //                   onTap: () async {
            //                     await showDialog(
            //                       context: context,
            //                       builder: (BuildContext context) {
            //                         return CrashAutoPlay();
            //                       },
            //                     );
            //                   },
            //                   child: Center(
            //                     child: Image.asset(
            //                       AppImages.refresh,
            //                       width: 16,
            //                       height: 16,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
          ),
          //SizedBox(height: 16),
          //! AUTOPLAY Button
          // if (_selectedValue == 1)
          //   Row(
          //     children: const [
          //       Expanded(
          //         child: Padding(
          //           padding: EdgeInsets.symmetric(horizontal: 8.0),
          //           child: CustomSlider(),
          //         ),
          //       ),
          //     ],
          //   ),
        ],
      ),
    );
  }

  //!Switch
  // Widget _buildSwitch() {
  //   return CustomSlidingSegmentedControl<int>(
  //     initialValue: _selectedValue,
  //     children: {
  //       0: Text(
  //         'Bet',
  //         style: Theme.of(context).textTheme.crashBodyMediumPrimary,
  //       ),
  //       1: Text(
  //         'Auto',
  //         style: Theme.of(context).textTheme.crashBodyMediumPrimary,
  //       ),
  //     },
  //     decoration: BoxDecoration(
  //       color: AppColors.crashEleventhColor,
  //       borderRadius: BorderRadius.circular(30),
  //       border: Border.all(color: AppColors.crashTwelfthColor, width: 1),
  //     ),
  //     thumbDecoration: BoxDecoration(
  //       color: AppColors.crashTwelfthColor,
  //       borderRadius: BorderRadius.circular(30),
  //     ),

  //     duration: const Duration(milliseconds: 200),
  //     curve: Curves.easeInOut,
  //     onValueChanged: (v) {
  //       setState(() => _selectedValue = v);
  //     },
  //   );
  // }

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
          fillColor: const Color.fromARGB(255, 54, 51, 51),
          hintStyle: Theme.of(context).textTheme.crashHeadlineSmall,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
          prefixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 5),
              // MIN button
              Container(
                height: 30,
                width: 40,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 102, 97, 97),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Text(
                    'Min',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  tooltip: 'Min (1)',
                  onPressed: () {
                    controller.text = '1';
                  },
                ),
              ),
              // DECREMENT button
              Material(
                type: MaterialType.transparency,
                child: IconButton(
                  splashRadius: 18,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.remove_circle_outline, size: 30),
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
            ],
          ),
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // INCREMENT button
              Material(
                type: MaterialType.transparency,
                child: IconButton(
                  splashRadius: 18,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add_circle_outline, size: 30),
                  onPressed: () {
                    final value =
                        int.tryParse(
                          controller.text.isEmpty ? '1' : controller.text,
                        ) ??
                        1;
                    if (value < 100) {
                      controller.text = (value + 1).toString();
                    } else {
                      controller.text = '100';
                    }
                  },
                  tooltip: 'Increment',
                ),
              ),
              // MAX button
              Material(
                type: MaterialType.transparency,
                child: Container(
                  height: 30,
                  width: 40,
                  decoration: BoxDecoration(
                    //    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 102, 97, 97),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    splashRadius: 18,
                    padding: EdgeInsets.zero,
                    icon: const Text(
                      'Max',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    tooltip: 'Max (100)',
                    onPressed: () {
                      controller.text = '100';
                    },
                  ),
                ),
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
        onChanged: (value) {
          if (_isUpdatingAmount) return;
          _isUpdatingAmount = true;
          final numValue = double.tryParse(value) ?? 0;
          if (numValue > 100) {
            controller.text = '100';
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: 3),
            );
          } else if (numValue < 1) {
            controller.text = '1';
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: 1),
            );
          }
          _isUpdatingAmount = false;
        },
      ),
    );
  }

  // OutlineInputBorder _borderStyle() {
  //   return OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(52),
  //     borderSide: BorderSide(color: AppColors.crashTwelfthColor),
  //   );
  // }

  //!Quick Amount Button
  // Widget _quickAmountButton(BuildContext context, String label, String value) {
  //   return CustomElevatedButton(
  //     onPressed: () => _setAmount(value),
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //     borderColor: AppColors.crashTwelfthColor,
  //     backgroundColor: AppColors.crashEleventhColor,
  //     borderRadius: 30,
  //     height: 28,
  //     elevation: 0,
  //     child: Text(
  //       label,
  //       style: Theme.of(context).textTheme.crashBodyMediumPrimary,
  //     ),
  //   );
  // }

  //!AUTOPLAY
  // Widget _buildAutoplayButton(BuildContext context) {
  //   final isAutoPlayActive = _autoPlayState.settings != null;
  //   final maxRounds = _autoPlayState.settings?.selectedRounds != null
  //       ? int.tryParse(_autoPlayState.settings!.selectedRounds!) ?? 0
  //       : 0;
  //   final currentRound = _autoPlayState.roundsPlayed;

  //   return Flexible(
  //     flex: 2,
  //     child: CustomElevatedButton(
  //       onPressed: () async {
  //         if (isAutoPlayActive) {
  //           // Stop autoplay
  //           _stopAutoPlay();
  //         } else {
  //           // Start autoplay - show dialog with callback
  //           await showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return AutoPlayWidget(
  //                 onStart: (settings) {
  //                   _startAutoPlay(settings);
  //                 },
  //               );
  //             },
  //           );
  //         }
  //       },
  //       padding: const EdgeInsets.symmetric(horizontal: 12),
  //       borderRadius: 52,
  //       backgroundColor: isAutoPlayActive
  //           ? AppColors
  //                 .crashFourteenthColor // Red color for stop
  //           : AppColors.crashFourteenthColor,
  //       hasBorder: true,
  //       height: 28,
  //       borderColor: isAutoPlayActive
  //           ? AppColors.crashFifteenthColor
  //           : AppColors.crashSixteenthColor,
  //       child: Text(
  //         isAutoPlayActive
  //             ? 'STOP ($currentRound/${maxRounds > 0 ? maxRounds : '∞'})'
  //             : 'AUTOPLAY',
  //         style: Theme.of(context).textTheme.crashBodyMediumPrimary,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ),
  //   );
  // }

  //!AUTO CASH OUT
  // Widget _buildAutoCashOutRow(BuildContext context) {
  //   return Expanded(
  //     flex: 4,
  //     child: Row(
  //       children: [
  //         // Label
  //         Expanded(
  //           child: Text(
  //             'Auto Cash Out',
  //             style: Theme.of(context).textTheme.crashbodySmallThird,
  //           ),
  //         ),
  //         // Switch
  //         Expanded(
  //           child: Transform.scale(
  //             scale: 0.65,

  //             child: Switch(
  //               value: _isSwitched,
  //               activeColor: AppColors.crashPrimaryColor,
  //               inactiveThumbColor: AppColors.crashPrimaryColor,
  //               activeTrackColor: AppColors.crashFifteenthColor,
  //               inactiveTrackColor: AppColors.crashEleventhColor,
  //               onChanged: (value) => setState(() => _isSwitched = value),
  //             ),
  //           ),
  //         ),
  //         // TextField
  //         Expanded(
  //           child: SizedBox(
  //             width: 70,
  //             height: 28,
  //             child: TextField(
  //               enabled: _isSwitched,
  //               controller: _switchController,
  //               keyboardType: const TextInputType.numberWithOptions(
  //                 decimal: true,
  //               ),
  //               textAlign: TextAlign.center,
  //               style: Theme.of(context).textTheme.crashBodyMediumSecondary,
  //               decoration: InputDecoration(
  //                 suffixText: "x",
  //                 suffixStyle: TextStyle(color: AppColors.crashThirteenthColor),
  //                 hintText: "1.5",
  //                 filled: true,
  //                 fillColor: AppColors.crashSecondaryColor,
  //                 contentPadding: const EdgeInsets.symmetric(
  //                   vertical: 4,
  //                   horizontal: 6,
  //                 ),
  //                 border: _borderStyle(),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  //! MANUAL BET
  // Widget _manualBetButton() {
  //   return CrashCustomBetButton(
  //     index: widget.index,
  //     amountController: _amountController,
  //     switchController: _switchController,
  //   );
  // }

  //! AUTO BET
  // Widget _autoBetButton() {
  //   return CrashCustomBetButton(
  //     index: widget.index,
  //     amountController: _autoAmountController,
  //     switchController: _switchController,
  //   );
  // }

  @override
  void dispose() {
    _amountController.removeListener(_enforceMaxValue);
    _autoAmountController.removeListener(_enforceMaxValue);
    _amountController.dispose();
    _autoAmountController.dispose();
    _switchController.dispose();
    super.dispose();
  }
}
