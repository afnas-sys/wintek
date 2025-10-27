import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';

class AutoPlayWidget extends StatefulWidget {
  const AutoPlayWidget({super.key});

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
    return AlertDialog(
      backgroundColor: Color(0XFF1a1c1c),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        height: 400,
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
                  color: Color(0XFF2d2d31),
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
                    color: Color(0XFF2d2d31),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Text(
                        'Number of rounds:',
                        style: Theme.of(
                          context,
                        ).textTheme.aviatorBodyMediumPrimary,
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
                (value) => setState(() => stopIfCashDecreases = value),
              ),
              SizedBox(height: 2),
              //!cash Increase
              autoPlayCondition(
                'Stop if cash increase by',
                _incrementController,
                stopIfCashIncreases,
                (value) => setState(() => stopIfCashIncreases = value),
              ),
              SizedBox(height: 2),

              //!single win exceeds
              autoPlayCondition(
                'Stop if single win exceeds',
                _exceedsController,
                stopIfSingleWinExceeds,
                (value) => setState(() => stopIfSingleWinExceeds = value),
              ),
              SizedBox(height: 20),

              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0XFF2d2d31),
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
                          onPressed: () {},
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
    );
  }

  Widget autoPlayCondition(
    String label,
    TextEditingController controller,
    bool switchValue,
    Function(bool) onSwitchChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Color(0XFF2d2d31),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
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
                  trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
                  activeColor: AppColors.aviatorFourteenthColor,
                  inactiveThumbColor: AppColors.aviatorTwentyTenthColor,

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
                          : AppColors.aviatorTwentyTenthColor,
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
      ),
    );
  }

  Widget _autoPlayButton(BuildContext context, String label) {
    return CustomElevatedButton(
      onPressed: () {
        setState(() {
          selectedRounds = label;
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
              Icons.add,
              enabled ? () => _increment(controller) : () {},
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
              Icons.remove,
              enabled ? () => _decrement(controller) : () {},
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
                ? AppColors.aviatorTertiaryColor
                : AppColors.aviatorTwentyTenthColor,
          ),
        ),
      ),
    );
  }
}
