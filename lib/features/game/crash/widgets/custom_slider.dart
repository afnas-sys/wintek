import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  final List<double> _steps = [
    for (double i = 1.0; i <= 1.9; i += 0.1) double.parse(i.toStringAsFixed(1)),
    2.5,
    for (int i = 3; i <= 10; i++) i.toDouble(),
    for (int i = 20; i <= 100; i += 10) i.toDouble(),
    for (int i = 200; i <= 500; i += 100) i.toDouble(),
    1000,
  ];

  double _sliderPosition = 0;

  double get _displayValue => _steps[_sliderPosition.round()];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // Multiplier text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Auto Cash Out:',
                  style: Theme.of(context).textTheme.crashBodyMediumSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  _sliderPosition == 0
                      ? 'OFF'
                      : _displayValue < 3
                      ? "x${_displayValue.toStringAsFixed(1)}"
                      : "x${_displayValue.toInt()}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.crashPrimaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),

            // OFF - Slider - MAX in a single row
            Row(
              children: [
                Text(
                  'OFF',
                  style: TextStyle(
                    color: AppColors.crashFifthColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 10,
                    child: SfSlider(
                      min: 0,
                      max: (_steps.length - 1).toDouble(),
                      value: _sliderPosition,
                      activeColor: AppColors.crashThirtySecondColor,
                      inactiveColor: AppColors.crashPrimaryColor,
                      stepSize: 1,
                      enableTooltip: false,
                      showLabels: false,
                      showTicks: false,
                      onChanged: (value) {
                        setState(() {
                          _sliderPosition = value;
                        });
                      },
                    ),
                  ),
                ),
                // const SizedBox(width: 8),
                Text(
                  'MAX',
                  style: TextStyle(
                    color: AppColors.crashFifthColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
