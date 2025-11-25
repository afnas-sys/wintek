import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/game/aviator/providers/aviator_round_provider.dart';

class SpinHistory extends ConsumerStatefulWidget {
  const SpinHistory({super.key});

  @override
  ConsumerState<SpinHistory> createState() => _SpinHistoryState();
}

class _SpinHistoryState extends ConsumerState<SpinHistory> {
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
    {
      'time': '14:33',
      'result': '42556',
      'bet': '₹50',
      'win/loss': '₹100',
      'net': '+150',
    },
    {
      'time': '12:24',
      'result': '425578',
      'bet': '₹60',
      'win/loss': '₹150',
      'net': '+150',
    },
    {
      'time': '11:33',
      'result': '42556',
      'bet': '₹50',
      'win/loss': '₹100',
      'net': '+150',
    },
    {
      'time': '14:33',
      'result': '42556',
      'bet': '₹50',
      'win/loss': '₹100',
      'net': '+150',
    },
    {
      'time': '14:33',
      'result': '42556',
      'bet': '₹50',
      'win/loss': '₹100',
      'net': '+150',
    },
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
                'Spin History: ${crashAllBets.length}',
                style: Theme.of(context).textTheme.aviatorBodyLargePrimary,
              ),
              //! Switch for PREVIOUS HAND
              CustomElevatedButton(
                // width: 125,
                // height: 28,
                padding: const EdgeInsets.only(
                  left: 7,
                  right: 7,
                  top: 6,
                  bottom: 6,
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
                    SizedBox(width: 6),
                    Text(
                      'Today',
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
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Time',
                  style: Theme.of(context).textTheme.spinBodyMediumThird,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Result',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.spinBodyMediumThird,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Bet.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.spinBodyMediumThird,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Win/Loss',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.spinBodyMediumThird,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Net',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.spinBodyMediumThird,
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          crashAllBets.isEmpty || crashAllBets.toString().isEmpty
              ? Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(
                    'No bets yet',
                    style: Theme.of(context).textTheme.spinBodyMediumFourth,
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: crashAllBets.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final bets = crashAllBets.toList()[index];
                    return Row(
                      children: [
                        // 📌 User
                        Expanded(
                          flex: 1,
                          child: Text(
                            bets['time'] ?? '',
                            textAlign: TextAlign.left,
                            style: Theme.of(
                              context,
                            ).textTheme.spinbodySmallSecondary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // 📌 Bet
                        Expanded(
                          flex: 1,
                          child: Text(
                            bets['result'] ?? '',
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.spinbodySmallSecondary,
                          ),
                        ),

                        // 📌 Mult
                        Expanded(
                          flex: 1,
                          child: Text(
                            bets['bet'] ?? '',
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.spinbodySmallSecondary,
                          ),
                        ),

                        // 📌 Win/Loss
                        Expanded(
                          flex: 1,
                          child: Text(
                            bets['win/loss'] ?? '',
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.spinbodySmallSecondary,
                          ),
                        ),

                        // 📌 Cashout
                        Expanded(
                          flex: 1,
                          child: Text(
                            bets['net'] ?? '',
                            textAlign: TextAlign.end,
                            style: Theme.of(
                              context,
                            ).textTheme.spinbodySmallSecondary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ],
      ),
    );
  }
}
