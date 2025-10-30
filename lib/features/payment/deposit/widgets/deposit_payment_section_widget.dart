import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';

class DepositPaymentSectionWidget extends StatelessWidget {
  const DepositPaymentSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Payment Method',
            style: Theme.of(context).textTheme.paymentSmallPrimary,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                _buildPaymentMethod('Google', AppImages.gpay, context),
                Container(
                  width: 1,
                  height: 80,
                  color: AppColors.paymentSecondaryColor,
                ),
                _buildPaymentMethod('PhonePe', AppImages.phonepay, context),
                Container(
                  width: 1,
                  height: 80,
                  color: AppColors.paymentSecondaryColor,
                ),
                _buildPaymentMethod('Paytm', AppImages.paytm, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String name, String image, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(image)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: Theme.of(context).textTheme.paymentSmallSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
