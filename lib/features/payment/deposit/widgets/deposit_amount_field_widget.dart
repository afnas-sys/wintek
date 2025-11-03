import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';

class DepositAmountFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const DepositAmountFieldWidget({super.key, required this.controller});

  @override
  State<DepositAmountFieldWidget> createState() =>
      _DepositAmountFieldWidgetState();
}

class _DepositAmountFieldWidgetState extends State<DepositAmountFieldWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Amount',
            style: Theme.of(context).textTheme.paymentSmallPrimary,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.paymentSecondaryColor),
            ),
            child: Row(
              children: [
                Text(
                  '₹',
                  style: Theme.of(context).textTheme.paymentSmallSecondary,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.paymentSmallSecondary,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter amount',
                      hintStyle: Theme.of(context).textTheme.paymentSmallThird,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          _buildQuickAmountSection(),
        ],
      ),
    );
  }

  Widget _buildQuickAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Amount',
          style: Theme.of(context).textTheme.paymentSmallPrimary,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildQuickAmountButton('₹ 100'),
            const SizedBox(width: 20),
            _buildQuickAmountButton('₹ 300'),
            const SizedBox(width: 20),
            _buildQuickAmountButton('₹ 500'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildQuickAmountButton('₹ 1000'),
            const SizedBox(width: 20),
            _buildQuickAmountButton('₹ 1500'),
            const SizedBox(width: 20),
            _buildQuickAmountButton('₹ 2000'),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAmountButton(String amount) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.controller.text = amount.replaceAll('₹ ', '');
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppColors.paymentSecondaryColor),
          ),
          child: Text(
            amount,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.paymentBodyLargeThird,
          ),
        ),
      ),
    );
  }
}
