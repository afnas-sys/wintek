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
  final _autoPlaycontroller = TextEditingController();

  _increment() {}
  _decrement() {}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0XFF1a1c1c),
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        decoration: BoxDecoration(
          color: AppColors.aviatorFourteenthColor,
          borderRadius: BorderRadius.circular(20),
        ),
        height: 400,
        width: double.infinity,
        child: Column(
          spacing: 1,
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
                    style: Theme.of(context).textTheme.aviatorBodyMediumPrimary,
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

            //cash Decrease
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0XFF2d2d31),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: stopIfCashDecreases,
                        onChanged: (value) {
                          setState(() {
                            stopIfCashDecreases = value;
                          });
                        },
                        thumbColor: WidgetStatePropertyAll(
                          AppColors.aviatorFifteenthColor,
                        ),
                        activeColor: AppColors.aviatorFourteenthColor,
                        //  inactiveThumbColor: AppColors.aviatorFourteenthColor,
                        inactiveTrackColor: AppColors.aviatorFourteenthColor
                            .withOpacity(0.5),
                      ),
                    ),
                    Text(
                      'Stop if cash decreases by',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorbodySmallPrimary,
                    ),

                    _buildAmountTextField(context, _autoPlaycontroller),
                  ],
                ),
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
          selectedRounds = label;
        });
        // TODO: Implement setting the number of rounds
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
    TextEditingController controller,
  ) {
    return SizedBox(
      width: 90,
      height: 36,
      child: TextField(
        controller: controller,
        cursorColor: AppColors.aviatorSixteenthColor,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.aviatorHeadlineSmall,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 8,
          ),
          // hintText: "1.00",
          hintStyle: Theme.of(context).textTheme.aviatorHeadlineSmall,
          filled: true,
          fillColor: AppColors.aviatorSixthColor,
          enabledBorder: _borderStyle(),
          disabledBorder: _borderStyle(),
          focusedBorder: _borderStyle(),
          prefixIcon: SizedBox(
            width: 20,
            child: _buildIconButton(Icons.remove, _decrement),
          ),
          suffixIcon: SizedBox(
            width: 20,
            child: _buildIconButton(Icons.add, _increment),
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
    return SizedBox(
      width: 6,
      height: 6,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: AppColors.aviatorTwentyFirstColor,
          borderRadius: BorderRadius.circular(52),
        ),
        child: Icon(icon, size: 6, color: AppColors.aviatorSixthColor),
      ),
    );
  }
}
