import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/game/aviator/providers/aviator_round_provider.dart';

class CrashAllBets extends ConsumerStatefulWidget {
  const CrashAllBets({super.key});

  @override
  ConsumerState<CrashAllBets> createState() => _AllBetsState();
}

class _AllBetsState extends ConsumerState<CrashAllBets> {
  int _currentPage = 0;
  static const int _itemsPerPage = 50;

  void _showPreviousHand() {
    final totalPages = (_betsLength / _itemsPerPage).ceil();
    if (totalPages == 0) {
      // No bets/pages yet, nothing to paginate
      return;
    }
    setState(() {
      _currentPage = (_currentPage + 1) % totalPages;
    });
  }

  int get _betsLength =>
      ref.watch(aviatorBetsNotifierProvider)?.bets.length ?? 0;

  List<Map<String, dynamic>> crashAllBets = [
    {'name': 'Ab', 'bet': '₹100', 'mult': '2.5x', 'cashoutINR': '250'},
    {'name': 'Cd', 'bet': '₹200', 'mult': '3.0x', 'cashoutINR': '600'},
    {'name': 'Ef', 'bet': '₹150', 'mult': '1.8x', 'cashoutINR': '270'},
    {'name': 'Gh', 'bet': '₹300', 'mult': '4.0x', 'cashoutINR': '1200'},
    {'name': 'Ij', 'bet': '₹250', 'mult': '2.2x', 'cashoutINR': '550'},
    {'name': 'Kl', 'bet': '₹400', 'mult': '5.0x', 'cashoutINR': '2000'},
    {'name': 'Mn', 'bet': '₹350', 'mult': '3.5x', 'cashoutINR': '1225'},
    {'name': 'Op', 'bet': '₹450', 'mult': '4.5x', 'cashoutINR': '2025'},
    {'name': 'Qr', 'bet': '₹500', 'mult': '6.0x', 'cashoutINR': '3000'},
    {'name': 'St', 'bet': '₹600', 'mult': '2.8x', 'cashoutINR': '1680'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.aviatorTertiaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.aviatorFifteenthColor, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL BETS: ${crashAllBets.length}',
                style: Theme.of(context).textTheme.aviatorBodyLargePrimary,
              ),
              //! Switch for PREVIOUS HAND
              CustomElevatedButton(
                width: 125,
                height: 28,
                padding: const EdgeInsets.only(
                  left: 7,
                  right: 7,
                  top: 5,
                  bottom: 4,
                ),
                borderRadius: 30,
                backgroundColor: AppColors.aviatorTwentiethColor,
                onPressed: _showPreviousHand,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      child: Image.asset(
                        AppImages.previousHand,
                        height: 20,
                        width: 20,
                        color: AppColors.aviatorSixthColor,
                      ),
                    ),
                    Text(
                      'Previous hand',
                      style: Theme.of(
                        context,
                      ).textTheme.aviatorBodyMediumFourth,
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
                    style: Theme.of(
                      context,
                    ).textTheme.aviatorBodyMediumSecondary,
                  ),
                ),
                SizedBox(width: 35),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Bet',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.aviatorBodyMediumSecondary,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Mult.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.aviatorBodyMediumSecondary,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Cash out',
                    textAlign: TextAlign.end,
                    style: Theme.of(
                      context,
                    ).textTheme.aviatorBodyMediumSecondary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          crashAllBets.isEmpty || crashAllBets.toString().isEmpty
              ? Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(
                    'No bets yet',
                    style: Theme.of(context).textTheme.aviatorBodyMediumFourth,
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: crashAllBets.length,
                  separatorBuilder: (context, index) => SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    bool isHighlighted =
                        (_currentPage * _itemsPerPage + index) == 0 ||
                        (_currentPage * _itemsPerPage + index) == 1;
                    Color? bgColor = isHighlighted
                        ? AppColors.aviatorTwentyFirstColor
                        : Color(0XFF222222).withOpacity(0.1);
                    final bets = crashAllBets.toList()[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: bgColor, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            // 👤 Avatar
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                color: AppColors.aviatorTertiaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            SizedBox(width: 12),

                            // 📌 User
                            Expanded(
                              flex: 2,
                              child: Text(
                                bets['name'] ?? '',
                                style: Theme.of(
                                  context,
                                ).textTheme.aviatorBodyLargePrimary,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // 📌 Bet
                            Expanded(
                              flex: 1,
                              child: Text(
                                bets['bet'] ?? '',
                                textAlign: TextAlign.center,
                                style: Theme.of(
                                  context,
                                ).textTheme.aviatorBodyLargePrimary,
                              ),
                            ),

                            // 📌 Mult
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 32,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.aviatorThirtyFiveColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  bets['mult'] ?? '',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.aviatorBodyLargeThird,
                                ),
                              ),
                            ),

                            // 📌 Cashout
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  bets['cashoutINR'] ?? '',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.aviatorBodyLargePrimary,
                                ),
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
