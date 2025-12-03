import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/game/crash/providers/recent_rounds_provider.dart';
import 'package:wintek/features/game/crash/service/crash_recent_rounds_service.dart';
import 'package:wintek/features/game/crash/domain/models/crash_recent_round_model.dart';

class CrashRecentRoundsWidget extends ConsumerStatefulWidget {
  const CrashRecentRoundsWidget({super.key});

  @override
  ConsumerState<CrashRecentRoundsWidget> createState() =>
      _CrashRecentRoundsWidgetState();
}

class _CrashRecentRoundsWidgetState
    extends ConsumerState<CrashRecentRoundsWidget> {
  bool showBalance = false;
  late final CrashRecentRoundsService recentRoundsService;

  @override
  void initState() {
    super.initState();
    recentRoundsService = ref.read(crashRecentRoundsServiceProvider);
    recentRoundsService.startListening();
  }

  @override
  void dispose() {
    recentRoundsService.stopListening();
    super.dispose();
  }

  // colors
  Color _getColor(String text) {
    final value = double.tryParse(text.replaceAll("x", "")) ?? 0;
    if (value < 2) {
      return AppColors.crashFortythColor;
    } else if (value < 10) {
      return AppColors.crashFortyFirstColor;
    } else {
      return AppColors.crashFortySecondColor;
    }
  }

  // container for showing the multiplied amount
  Widget _chip(String text, BuildContext context) {
    final color = _getColor(text);
    return Container(
      height: 32,
      width: 55,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: Theme.of(context).textTheme.crashbodySmallPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentRoundsService = ref.watch(crashRecentRoundsServiceProvider);
    return StreamBuilder<List<CrashRecentRounds>>(
      stream: recentRoundsService.roundsStream,
      builder: (context, snapshot) {
        List<String> multipliers = [];
        if (snapshot.hasData) {
          final crashedRounds = snapshot.data!
              .where((round) => round.crashAt != null && round.endedAt != null)
              .toList();
          multipliers = crashedRounds
              .take(16)
              .map((round) => "${round.crashAt!}x")
              .toList();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // first row → 4 chips + button
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < 4 && i < multipliers.length; i++)
                  Expanded(child: _chip(multipliers[i], context)),
                // Button for showing Balance history of the multiplier
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => showBalance = !showBalance),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.crashFortyThirdColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: AppColors.crashFortyFourthColor,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      minimumSize: const Size(55, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          FontAwesomeIcons.clock,
                          size: 16,
                          color: AppColors.crashPrimaryColor,
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          showBalance
                              ? FontAwesomeIcons.angleUp
                              : FontAwesomeIcons.angleDown,
                          size: 16,
                          color: AppColors.crashPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            //  second row → wrap chips in multiple lines
            if (showBalance)
              Wrap(
                runSpacing: 8,
                children: [
                  for (int i = 4; i < multipliers.length; i++)
                    _chip(multipliers[i], context),
                ],
              ),
          ],
        );
      },
    );
  }
}
