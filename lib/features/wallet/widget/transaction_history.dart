import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:wintek/utils/constants/app_colors.dart';
import 'package:wintek/utils/constants/app_images.dart';
import 'package:wintek/utils/constants/theme.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List<Map<String, dynamic>> data = [
    {'title': 'withdrawal', 'date': '12/04/2023'},
    {'title': 'withdr', 'date': '12/04/2026'},
    {'title': 'withdrawal', 'date': '12/04/2023'},
    {'title': 'withdr', 'date': '12/04/2026'},
    {'title': 'withdrawal', 'date': '12/04/2023'},
    {'title': 'withdr', 'date': '12/04/2026'},
    {'title': 'withdrawal', 'date': '12/04/2023'},
    {'title': 'withdr', 'date': '12/04/2026'},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        color: AppColors.walletThirteenthColor,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Transaction History',
                style: Theme.of(context).textTheme.walletTitleMediumPrimary,
              ),
              Spacer(),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.walletFourteenthColor),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.asset(
                    AppImages.linearSetting,
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            lineThickness: 1.0,
            dashLength: 4.0,
            dashColor: AppColors.walletFifteenthColor,
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              //  physics: AlwaysScrollableScrollPhysics(),
              physics: BouncingScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (context, index) {
                return DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: AppColors.walletFifteenthColor,
                );
              },
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  leading: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.walletSixteenthColor),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset(AppImages.send, height: 16, width: 16),
                  ),
                  title: Text(
                    item['title'],
                    style: Theme.of(context).textTheme.walletBodyMediumPrimary,
                  ),
                  subtitle: Text(
                    item['date'],
                    style: Theme.of(context).textTheme.walletBodySmallPrimary,
                  ),
                  trailing: Column(
                    children: [
                      Text(
                        '₹ 5000',
                        style: Theme.of(
                          context,
                        ).textTheme.walletBodyMediumSecondary,
                      ),
                      Text(
                        'Pending',
                        style: Theme.of(
                          context,
                        ).textTheme.walletBodySmallSecondary,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
