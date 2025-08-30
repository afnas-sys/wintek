import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:wintek/utils/app_colors.dart';
import 'package:wintek/utils/app_images.dart';
import 'package:wintek/utils/theme.dart';

class CustomHomeAppbar extends StatefulWidget {
  const CustomHomeAppbar({super.key});

  @override
  State<CustomHomeAppbar> createState() => _CustomHomeAppbarState();
}

class _CustomHomeAppbarState extends State<CustomHomeAppbar> {
  int _selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.homeSecondaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            child: Image.asset(
              AppImages.homeAppBarImage,
              height: 24,
              width: 92,
            ),
          ),
          Spacer(),

          Row(
            children: [
              //! SWITCH
              CustomSlidingSegmentedControl<int>(
                initialValue: _selectedValue,
                children: {
                  0: Text(
                    '₹ 5000',
                    style: Theme.of(context).textTheme.bodySmallPrimaryBold,
                  ),
                  1: Text(
                    'Deposit',
                    style: Theme.of(context).textTheme.bodySmallPrimaryBold,
                  ),
                },
                decoration: BoxDecoration(
                  color: AppColors.homeThirdColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.homeFourththColor,
                    width: 1,
                  ),
                ),
                thumbDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.homeFivethColor,
                      AppColors.homeSxithColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),

                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                onValueChanged: (v) {
                  setState(() => _selectedValue = v);
                },
              ),
              SizedBox(width: 8),
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColors.homeSecondaryColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                alignment: Alignment.center,
                child: Image.asset(AppImages.homeAppbarImage),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
