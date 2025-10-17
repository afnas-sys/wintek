import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/core/constants/app_colors.dart';

class BalanceContainer extends StatelessWidget {
  const BalanceContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      width: 396,
      height: 134,
      decoration: BoxDecoration(
        color: AppColors.aviatorSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance: ₹0.00',
            style: Theme.of(context).textTheme.aviatorBodyTitleMdeium,
          ),
          SizedBox(height: 19),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  //!Button for withdraw
                  _withdrawButton(context),
                  SizedBox(width: 20),

                  //!Button for deposit
                  _depositButton(context),
                ],
              ),

              //! icon for Refresh
              _refreshButton(),
            ],
          ),
        ],
      ),
    );
  }

  //! Button for withdraw
  Widget _withdrawButton(BuildContext context) {
    return CustomElevatedButton(
      hasBorder: false,
      onPressed: () {},
      backgroundColor: AppColors.aviatorFourthColor,
      borderRadius: 30,
      padding: EdgeInsets.only(left: 23, right: 23, top: 10, bottom: 10),
      height: 40,
      width: 111,
      child: Text(
        'Withdraw',
        style: Theme.of(context).textTheme.aviatorBodyLargeSecondary,
      ),
    );
  }

  //! Button for deposit
  Widget _depositButton(BuildContext context) {
    return CustomElevatedButton(
      hasBorder: false,
      onPressed: () {},
      backgroundColor: AppColors.aviatorFifthColor,
      borderRadius: 30,
      padding: EdgeInsets.only(left: 23, right: 23, top: 10, bottom: 10),
      height: 40,
      width: 100,
      child: Text(
        'Deposit',
        style: Theme.of(context).textTheme.aviatorBodyLargeSecondary,
      ),
    );
  }

  //! Refresh Button
  Widget _refreshButton() {
    return Row(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {},
          child: Icon(
            FontAwesomeIcons.rotate,
            size: 20,
            color: AppColors.aviatorTertiaryColor,
            weight: 10,
          ),
        ),
      ],
    );
  }
}
