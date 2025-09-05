import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/utils/constants/app_colors.dart';
import 'package:wintek/utils/constants/theme.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';

class MyBets extends StatefulWidget {
  const MyBets({super.key});

  @override
  State<MyBets> createState() => _MyBetsState();
}

class _MyBetsState extends State<MyBets> {
  final List<Map<String, String>> data = [
    {"date": "13:46", "bet": "₹100", "X": "2.57x", "cashout": "\$100"},
    {"date": "13:46", "bet": "₹100", "X": "2.57x", "cashout": "\$45"},
    {"date": "13:46", "bet": "₹100", "X": "2.57x", "cashout": "\$210"},
    {"date": "13:46", "bet": "₹100", "X": "2.57x", "cashout": "\$24"},
    {"date": "13:46", "bet": "₹100", "X": "2.57x", "cashout": "\$250"},
    {"date": "13:46", "bet": "₹100", "X": "2.57x", "cashout": "\$11"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.aviatorFourteenthColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL BETS: 517',
                style: Theme.of(context).textTheme.aviatorBodyLargePrimary,
              ),
              //! Switch for PREVIOUS HAND
              CustomElevatedButton(
                width: 125,
                height: 28,
                padding: const EdgeInsets.only(
                  left: 7,
                  right: 7,
                  top: 6,
                  bottom: 6,
                ),
                borderRadius: 30,
                backgroundColor: AppColors.aviatorFifteenthColor,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      FontAwesomeIcons.clockRotateLeft,
                      size: 16,
                      color: AppColors.aviatorTertiaryColor,
                    ),
                    Text(
                      'Previous hand',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorBodyMediumPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 36,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Date',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorBodyMediumSecondary,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Bet, INR',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorBodyMediumSecondary,
                    ),
                  ),
                  SizedBox(width: 25),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'X',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorBodyMediumSecondary,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Cash out, INR',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorBodyMediumSecondary,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorBodyMediumSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 8),

          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (context, index) => SizedBox(height: 6),
            itemBuilder: (context, index) {
              final item = data[index];
              bool isHighlighted = index == 0;
              Color? bgColor = isHighlighted
                  ? AppColors.aviatorTwentySecondColor
                  : AppColors.aviatorTwentyFirstColor;

              return Container(
                width: double.infinity,
                height: 36,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: bgColor, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // 📌 Date
                      Expanded(
                        flex: 1,
                        child: Text(
                          item['date'] ?? '',
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorBodyLargePrimary,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // 📌 Bet, INR
                      Expanded(
                        flex: 1,
                        child: Text(
                          item['bet'] ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorBodyLargePrimary,
                        ),
                      ),

                      // 📌 X
                      Container(
                        height: 28,
                        width: 50,

                        decoration: BoxDecoration(
                          color: AppColors.aviatorTwentyThirdColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            item['X'] ?? '',
                            style: Theme.of(
                              context,
                            ).textTheme.aviatorbodySmallSecondary,
                          ),
                        ),
                      ),

                      // 📌 Cashout
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            item['cashout'] ?? '',
                            style: Theme.of(
                              context,
                            ).textTheme.aviatorBodyLargePrimary,
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/shield.png',
                              height: 22,
                              width: 22,
                            ),
                            Icon(
                              FontAwesomeIcons.comment,
                              size: 20,
                              color: AppColors.aviatorSixteenthColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
