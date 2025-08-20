import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:winket/utils/app_colors.dart';
import 'package:winket/utils/theme.dart';
import 'package:winket/utils/widgets/custom_elevated_button.dart';

class BetContainer extends StatefulWidget {
  const BetContainer({super.key});

  @override
  State<BetContainer> createState() => _BetContainerState();
}

class _BetContainerState extends State<BetContainer> {
  int _selectedValue = 0;
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    //!-----!BET CONTAINER------

    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      //  curve: Curves.easeInOut,
      height: _selectedValue == 0 ? 210 : 258,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgTenthColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderThirdColor, width: 1),
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
                child: CustomSlidingSegmentedControl<int>(
                  initialValue: _selectedValue,
                  children: {
                    0: Text(
                      'Bet',
                      style: Theme.of(context).textTheme.bodySmallPrimaryBold,
                    ),
                    1: Text(
                      'Auto',
                      style: Theme.of(context).textTheme.bodySmallPrimaryBold,
                    ),
                  },
                  decoration: BoxDecoration(
                    color: AppColors.bgTenthColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.borderThirdColor,
                      width: 1,
                    ),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: AppColors.switchThumbColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  //  padding: 18,
                  // height: 36, // controls minHeight
                  // fixedWidth: 90,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  onValueChanged: (v) {
                    setState(() => _selectedValue = v);
                  },
                ),
              ),
              //! TOP RIGHT SIDED BUTTON '-'
              CustomElevatedButton(
                hasBorder: true,
                borderColor: AppColors.borderThirdColor,
                backgroundColor: AppColors.bgTenthColor,
                padding: EdgeInsetsGeometry.all(2),
                height: 22,
                width: 22,
                onPressed: () {},
                child: Icon(
                  Icons.remove,
                  size: 18.33,
                  color: AppColors.iconTertiaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            child: Center(
              child: _selectedValue == 0
                  ? Row(
                      children: [
                        SizedBox(height: 16),
                        Column(
                          children: [
                            //! container for Amount, + & - button
                            Container(
                              width: 154,
                              height: 40,
                              padding: EdgeInsets.only(
                                left: 30,
                                right: 8,
                                top: 2,
                                bottom: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.bgThirteenthColor,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColors.borderThirdColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '1:00',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMediumTitle3Primary,
                                  ),
                                  Row(
                                    children: [
                                      CustomElevatedButton(
                                        hasBorder: false,
                                        backgroundColor:
                                            AppColors.bgNinethColor,
                                        padding: EdgeInsetsGeometry.all(2),
                                        height: 22,
                                        width: 22,
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.remove,
                                          size: 18.33,
                                          color: AppColors.iconSecondaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      CustomElevatedButton(
                                        hasBorder: false,
                                        backgroundColor:
                                            AppColors.bgNinethColor,
                                        padding: EdgeInsetsGeometry.all(2),
                                        height: 22,
                                        width: 22,
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.add,
                                          size: 18.33,
                                          color: AppColors.iconSecondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            //! BUTTON FOR ₹10 & ₹20
                            Row(
                              children: [
                                CustomElevatedButton(
                                  onPressed: () {},
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  text: '₹10',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColors.buttonTertiaryTextColor,
                                  borderColor: AppColors.borderThirdColor,
                                  backgroundColor: AppColors.bgTenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
                                  elevation: 0,
                                ),

                                SizedBox(width: 6),

                                CustomElevatedButton(
                                  onPressed: () {},
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  text: '₹20',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColors.buttonTertiaryTextColor,
                                  borderColor: AppColors.borderThirdColor,
                                  backgroundColor: AppColors.bgTenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
                                  elevation: 0,
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            //! BUTTON FOR ₹50 & ₹100
                            Row(
                              children: [
                                CustomElevatedButton(
                                  onPressed: () {},
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  text: '₹50',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColors.buttonTertiaryTextColor,
                                  borderColor: AppColors.borderThirdColor,
                                  backgroundColor: AppColors.bgTenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
                                  elevation: 0,
                                ),

                                SizedBox(width: 6),

                                CustomElevatedButton(
                                  onPressed: () {},
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  text: '₹100',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColors.buttonTertiaryTextColor,
                                  borderColor: AppColors.borderThirdColor,
                                  backgroundColor: AppColors.bgTenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
                                  elevation: 0,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        //! BUTTON FOR BET
                        CustomElevatedButton(
                          onPressed: () {},
                          text: 'BET',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          height: 108,
                          width: 171,
                          backgroundColor: AppColors.bgEleventhColor,
                          borderRadius: 20,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(height: 16),
                        Column(
                          children: [
                            //! container for Amount, + & - button
                            Container(
                              width: 154,
                              height: 40,
                              padding: EdgeInsets.only(
                                left: 30,
                                right: 8,
                                top: 2,
                                bottom: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.bgThirteenthColor,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColors.borderThirdColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '1:00',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMediumTitle3Primary,
                                  ),
                                  Row(
                                    children: [
                                      CustomElevatedButton(
                                        hasBorder: false,
                                        backgroundColor:
                                            AppColors.bgNinethColor,
                                        padding: EdgeInsetsGeometry.all(2),
                                        height: 22,
                                        width: 22,
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.remove,
                                          size: 18.33,
                                          color: AppColors.iconSecondaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      CustomElevatedButton(
                                        hasBorder: false,
                                        backgroundColor:
                                            AppColors.bgNinethColor,
                                        padding: EdgeInsetsGeometry.all(2),
                                        height: 22,
                                        width: 22,
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.add,
                                          size: 18.33,
                                          color: AppColors.iconSecondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            //! BUTTON FOR AMOUNT
                            Row(
                              children: [
                                CustomElevatedButton(
                                  onPressed: () {},
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  text: '₹10',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColors.buttonTertiaryTextColor,
                                  borderColor: AppColors.borderThirdColor,
                                  backgroundColor: AppColors.bgTenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
                                  elevation: 0,
                                ),

                                SizedBox(width: 6),

                                CustomElevatedButton(
                                  onPressed: () {},
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  text: '₹20',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColors.buttonTertiaryTextColor,
                                  borderColor: AppColors.borderThirdColor,
                                  backgroundColor: AppColors.bgTenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
                                  elevation: 0,
                                ),
                              ],
                            ),
                            SizedBox(height: 6),

                            //! BUTTON FOR AMOUNT
                            Row(
                              children: [
                                CustomElevatedButton(
                                  onPressed: () {},
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  text: '₹50',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColors.buttonTertiaryTextColor,
                                  borderColor: AppColors.borderThirdColor,
                                  backgroundColor: AppColors.bgTenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
                                  elevation: 0,
                                ),

                                SizedBox(width: 6),

                                CustomElevatedButton(
                                  onPressed: () {},
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  text: '₹100',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColors.buttonTertiaryTextColor,
                                  borderColor: AppColors.borderThirdColor,
                                  backgroundColor: AppColors.bgTenthColor,
                                  borderRadius: 30,
                                  height: 28,
                                  width: 74,
                                  elevation: 0,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        //! BUTTON FOR BET
                        CustomElevatedButton(
                          onPressed: () {},
                          text: 'BET',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          height: 108,
                          width: 171,
                          backgroundColor: AppColors.bgEleventhColor,
                          borderRadius: 20,
                        ),
                      ],
                    ),
            ),
          ),

          SizedBox(height: 16),
          //! AUTOPLAY Button
          if (_selectedValue == 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  onPressed: () {},
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  borderRadius: 52,
                  backgroundColor: AppColors.bgTwelfthColor,
                  text: 'AUTOPLAY',
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.buttonTertiaryTextColor,
                  fontSize: 14,
                  width: 98,
                  height: 28,
                  borderColor: AppColors.borderFourthColor,
                ),
                Row(
                  children: [
                    //! Auto cash oout Text
                    Text(
                      'Auto Cash Out',
                      style: Theme.of(context).textTheme.bodySmallPrimaryBold,
                    ),
                    //! Switch
                    SizedBox(width: 2),
                    Transform.scale(
                      scale: 0.70,
                      child: Switch(
                        value: _isSwitched,
                        activeColor: AppColors.switchThumbActiveColor,
                        inactiveThumbColor: AppColors.switchThumbInactiveColor,
                        activeTrackColor: AppColors.switchActiveColor,
                        inactiveTrackColor: AppColors.bgTenthColor,
                        onChanged: (value) {
                          setState(() {
                            _isSwitched = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 2),
                    //! Button for 1.5 X
                    CustomElevatedButton(
                      height: 28,
                      width: 74,
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 6,
                        bottom: 6,
                      ),
                      backgroundColor: AppColors.bgThirteenthColor,
                      borderRadius: 52,
                      elevation: 0,
                      borderColor: AppColors.borderFifthColor,
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1.5',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmallSecondaryBold,
                          ),
                          Text(
                            'X',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmallSecondaryBold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                //ToggleButtons(children: [], isSelected: isSelected)
              ],
            ),
        ],
      ),
    );
  }
}
