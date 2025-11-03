import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';

class WithdrawHistoryWidget extends StatelessWidget {
  const WithdrawHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 348,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 26),
      decoration: const BoxDecoration(
        color: AppColors.paymentFourteenthColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHistoryHeader(context),
          const SizedBox(height: 24),
          _buildHistoryTableHeader(context),
          const SizedBox(height: 16),
          _buildDashedDivider(),
          const SizedBox(height: 16),
          Expanded(child: _buildHistoryList()),
        ],
      ),
    );
  }

  Widget _buildHistoryHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Withdraw History',
            style: Theme.of(context).textTheme.paymentTitleMediumPrimary,
          ),
        ),
        Container(
          height: 44,
          width: 44,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppColors.paymentSixteenthColor),
            image: DecorationImage(image: AssetImage(AppImages.linearSetting)),
          ),
          // child: const Icon(Icons.tune, color: Colors.white, size: 16),
        ),
      ],
    );
  }

  Widget _buildHistoryTableHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              'Amount',
              style: Theme.of(context).textTheme.paymentBodySmallSecondary,
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              'Date',
              style: Theme.of(context).textTheme.paymentBodySmallSecondary,
            ),
          ),
          SizedBox(
            width: 74,
            child: Text(
              'Status',
              style: Theme.of(context).textTheme.paymentBodySmallSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return DottedLine(
      dashColor: AppColors.paymentEighteenthColor,
      dashLength: 8,
      dashGapLength: 4,
      lineThickness: 1,
    );
  }

  Widget _buildHistoryList() {
    final List<Map<String, String>> history = [
      {'amount': '₹3,000', 'date': '07 Jul, 11:30 AM', 'status': 'Pending'},
      {'amount': '₹3,000', 'date': '04 Jul, 11:30 AM', 'status': 'Successful'},
      {'amount': '₹3,000', 'date': '04 Jul, 11:30 AM', 'status': 'Failed'},
      {'amount': '₹3,000', 'date': '04 Jul, 11:30 AM', 'status': 'Successful'},
    ];

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: history.length,
      separatorBuilder: (context, index) => Column(
        children: [
          const SizedBox(height: 20),
          DottedLine(
            dashColor: AppColors.paymentEighteenthColor,
            dashLength: 8,
            dashGapLength: 4,
            lineThickness: 1,
          ),
          const SizedBox(height: 20),
        ],
      ),
      itemBuilder: (context, index) {
        final item = history[index];
        return _buildHistoryItem(
          item['amount']!,
          item['date']!,
          item['status']!,
          context,
        );
      },
    );
  }

  Widget _buildHistoryItem(
    String amount,
    String date,
    String status,
    BuildContext context,
  ) {
    Color statusColor;
    switch (status) {
      case 'Pending':
        statusColor = AppColors.paymentNinteenthColor;
        break;
      case 'Successful':
        statusColor = AppColors.paymentTwentythColor;
        break;
      case 'Failed':
        statusColor = AppColors.paymentTwentyfirstColor;
        break;
      default:
        statusColor = AppColors.paymentFifteenthColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              amount,
              style: Theme.of(context).textTheme.paymentSmallSecondary,
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              date,
              style: Theme.of(context).textTheme.paymentSmallSecondary,
            ),
          ),
          SizedBox(
            width: 74,
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
