import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:winket/utils/app_colors.dart';
import 'package:winket/utils/theme.dart';
import 'package:winket/utils/widgets/custom_elevated_button.dart';

class AllBets extends StatefulWidget {
  const AllBets({super.key});

  @override
  State<AllBets> createState() => _AllBetsState();
}

class _AllBetsState extends State<AllBets> {
  final List<Map<String, String>> data = [
    {"user": "Alice", "bet": "50", "mult": "2x", "cashout": "\$100"},
    {"user": "Bob", "bet": "30", "mult": "1.5x", "cashout": "\$45"},
    {"user": "Charlie", "bet": "70", "mult": "3x", "cashout": "\$210"},
    {"user": "Diana", "bet": "20", "mult": "1.2x", "cashout": "\$24"},
    {"user": "Eve", "bet": "100", "mult": "2.5x", "cashout": "\$250"},
    {"user": "Frank", "bet": "10", "mult": "1.1x", "cashout": "\$11"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bgTenthColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL BETS: 517',
                style: Theme.of(context).textTheme.bodyMediumPrimaryBold,
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
                backgroundColor: AppColors.bgEighteenthColor,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      FontAwesomeIcons.clockRotateLeft,
                      size: 16,
                      color: AppColors.iconPrimaryColor,
                    ),
                    Text(
                      'Previous hand',
                      style: Theme.of(context).textTheme.bodySmallPrimaryBold,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'User',
                    style: Theme.of(context).textTheme.bodySmallSecondary,
                  ),
                ),
                SizedBox(width: 35),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Bet',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmallSecondary,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Mult.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmallSecondary,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Cash out',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodySmallSecondary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          ListView.separated(
            shrinkWrap: true,
            physics:
                NeverScrollableScrollPhysics(), // 👈 avoid scroll inside column
            itemCount: data.length,
            separatorBuilder: (context, index) => SizedBox(height: 6),
            itemBuilder: (context, index) {
              final item = data[index];
              Color? bgColor;
              if (index == 0) {
                bgColor = AppColors.bgNineteenthColor; // first item background
              } else if (index == 1) {
                bgColor = AppColors.bgNineteenthColor; // second item background
              } else {
                bgColor = AppColors.bgTwentyFirstColor; // default (transparent)
              }
              return Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: bgColor,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // 👤 Avatar
                      CircleAvatar(
                        radius: 18,
                        child: Icon(FontAwesomeIcons.user, size: 14),
                      ),
                      SizedBox(width: 12),

                      // 📌 User
                      Expanded(
                        flex: 2,
                        child: Text(
                          item['user'] ?? '',
                          style: Theme.of(context).textTheme.bodyMediumPrimary,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // 📌 Bet
                      Expanded(
                        flex: 1,
                        child: Text(
                          item['bet'] ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMediumPrimary,
                        ),
                      ),

                      // 📌 Mult
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 32,
                          width: 50,
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 6,
                            bottom: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bgTwentythColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            item['mult'] ?? '',
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMediumPrimary,
                          ),
                        ),
                      ),

                      // 📌 Cashout
                      Expanded(
                        flex: 1,
                        child: Text(
                          item['cashout'] ?? '',
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.bodyMediumPrimary,
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
