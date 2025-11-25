import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/game/spin_to_win/widgets/spin_auto_play_widget.dart';

class SpinBetButton extends StatefulWidget {
  final VoidCallback? onSpin;

  const SpinBetButton({super.key, this.onSpin});

  @override
  State<SpinBetButton> createState() => _SpinBetButtonState();
}

class _SpinBetButtonState extends State<SpinBetButton> {
  TextEditingController betAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.spinToWinPrimaryColor,
        border: Border.all(color: AppColors.spinToWinTertiaryColor, width: 1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bet Amount',
            style: Theme.of(context).textTheme.spinBodyMediumPrimary,
          ),

          SizedBox(
            height: 54,
            child: TextField(
              showCursor: true,
              cursorColor: AppColors.spinToWinFourthColor,
              cursorHeight: 18,
              enableInteractiveSelection: false,
              controller: betAmountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.spinBodyTitleSmall,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                filled: true,
                fillColor: AppColors.spinToWinFifthColor,
                hintText: 'Enter Amount',
                hintStyle: Theme.of(context).textTheme.spinBodyTitleSmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: AppColors.spinSixthColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: AppColors.spinSixthColor,
                    width: 2,
                  ),
                ),

                suffixIconConstraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      splashRadius: 18,
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        size: 30,
                        color: AppColors.spinToWinFourthColor,
                      ),
                      onPressed: () {
                        final value =
                            int.tryParse(
                              betAmountController.text.isEmpty
                                  ? '1'
                                  : betAmountController.text,
                            ) ??
                            1;
                        if (value > 1) {
                          betAmountController.text = (value - 1).toString();
                        } else {
                          betAmountController.text = '1';
                        }
                      },
                      tooltip: 'Decrement',
                    ),
                  ),
                ),

                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      splashRadius: 18,
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 30,
                        color: AppColors.spinToWinFourthColor,
                      ),
                      onPressed: () {
                        int value = int.tryParse(betAmountController.text) ?? 0;
                        betAmountController.text = (value + 1).toString();
                      },
                      tooltip: 'Increment',
                    ),
                  ),
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _autoPlayButton(context, '10'),
              const SizedBox(width: 8),
              _autoPlayButton(context, '50'),
              const SizedBox(width: 8),
              _autoPlayButton(context, '100'),
              const SizedBox(width: 8),
              _autoPlayButton(context, '200'),
              const SizedBox(width: 8),
              _autoPlayButton(context, '500'),
              const SizedBox(width: 8),
              _autoPlayButton(context, '1000'),
            ],
          ),
          SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.spinToWinSeventhColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(
                          color: AppColors.spinToWinSeventhColor,
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SpinToWinAutoPlay();
                        },
                      );
                    },
                    child: Text(
                      'Autoplay',
                      style: Theme.of(
                        context,
                      ).textTheme.spinBodyMediumSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.spinToWinFifteenthColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: widget.onSpin,
                    child: Text(
                      'Spin Now',
                      style: Theme.of(
                        context,
                      ).textTheme.spinBodyMediumSecondary,
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
          betAmountController.text = label;
        });
      },
      width: 50,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      borderColor: AppColors.spinToWinNinthColor,
      backgroundColor: AppColors.spinToWinTenthColor,
      borderRadius: 50,
      height: 28,
      elevation: 0,
      isSelected: betAmountController.text == label,
      selectedBackgroundColor: AppColors.spinToWinFourthColor,
      child: Text(
        label,
        style: Theme.of(context).textTheme.spinBodyMediumPrimary,
      ),
    );
  }
}
