import 'package:flutter/material.dart';
import 'package:wintek/utils/constants/app_colors.dart';
import 'package:wintek/utils/constants/theme.dart';

class DayWidget extends StatefulWidget {
  const DayWidget({super.key});

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  final List<Map<String, String>> data = [
    {"user": "Alice", "win": "100.00x", "cashout": "100.00x"},
    {"user": "Bob", "win": "100.00x", "cashout": "100.00x"},
    {"user": "Charlie", "win": "100.00x", "cashout": "100.00x"},
    {"user": "Diana", "win": "100.00x", "cashout": "100.00x"},
    {"user": "Eve", "win": "100.00x", "cashout": "100.00x"},
    {"user": "Frank", "win": "100.00x", "cashout": "100.00x"},
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
            color: AppColors.aviatorSixthColor,
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
                      color: AppColors.aviatorTertiaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  SizedBox(height: 2),
                  //User name
                  Text(
                    item['user']!,
                    style: Theme.of(context).textTheme.aviatorBodyLargePrimary,
                  ),
                ],
              ),

              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Cash out:  ',
                        style: Theme.of(
                          context,
                        ).textTheme.aviatorBodyMediumSecondary,
                      ),
                      //! container for cash out- 100
                      Container(
                        height: 24,
                        width: 73,
                        padding: const EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: 8,
                          right: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.aviatorTwentyFifthColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          item['cashout']!,
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorbodySmallPrimary,
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
                        style: Theme.of(
                          context,
                        ).textTheme.aviatorBodyMediumSecondary,
                      ),
                      //! container for win- 100
                      Container(
                        height: 24,
                        width: 73,
                        padding: const EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: 8,
                          right: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.aviatorTwentyFifthColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          item['cashout']!,
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorbodySmallPrimary,
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
