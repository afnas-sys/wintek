import 'package:flutter/material.dart';
import 'package:wintek/utils/app_colors.dart';
import 'package:wintek/utils/theme.dart';

class MonthWidget extends StatefulWidget {
  const MonthWidget({super.key});

  @override
  State<MonthWidget> createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  final List<Map<String, String>> data = [
    {"user": "Alice", "win": "10000.00x", "cashout": "10000.00x"},
    {"user": "Bob", "win": "10000.00x", "cashout": "10000.00x"},
    {"user": "Charlie", "win": "10000.00x", "cashout": "10000.00x"},
    {"user": "Diana", "win": "10000.00x", "cashout": "10000.00x"},
    {"user": "Eve", "win": "10000.00x", "cashout": "10000.00x"},
    {"user": "Frank", "win": "10000.00x", "cashout": "10000.00x"},
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 6);
      },
      itemBuilder: (context, index) {
        final item = data[index];
        return Container(
          height: 71,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.bgThirteenthColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  //Container for avatar
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.bgTwentySecondColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  SizedBox(height: 2),
                  //User name
                  Text(
                    item['user']!,
                    style: Theme.of(context).textTheme.bodyMediumPrimary,
                  ),
                ],
              ),

              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Cash out:  ',
                        style: Theme.of(context).textTheme.bodySmallSecondary,
                      ),
                      //! container for cash out- 10000
                      Container(
                        height: 24,
                        width: 73,
                        padding: const EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: 2,
                          right: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgTwentythColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          item['cashout']!,
                          style: Theme.of(context).textTheme.bodySmallPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '         Win:  ',
                        style: Theme.of(context).textTheme.bodySmallSecondary,
                      ),
                      //! container for win- 10000
                      Container(
                        height: 24,
                        width: 73,
                        padding: const EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: 2,
                          right: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgTwentythColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          item['win']!,
                          style: Theme.of(context).textTheme.bodySmallPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
