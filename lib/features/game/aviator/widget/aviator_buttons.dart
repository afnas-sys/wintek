import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/game/aviator/providers/recent_rounds_provider.dart';
import 'package:wintek/features/game/aviator/domain/models/rounds.dart';

class AviatorButtons extends ConsumerStatefulWidget {
  const AviatorButtons({super.key});

  @override
  ConsumerState<AviatorButtons> createState() => _AviatorButtonsState();
}

class _AviatorButtonsState extends ConsumerState<AviatorButtons> {
  bool showBalance = false;
  // colors
  Color _getColor(String text) {
    final value = double.tryParse(text.replaceAll("x", "")) ?? 0;
    if (value < 2) {
      return AppColors.aviatorSeventhColor;
    } else if (value < 10) {
      return AppColors.aviatorEighthColor;
    } else {
      return AppColors.aviatorNinthColor;
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
        style: Theme.of(context).textTheme.aviatorbodySmallPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentRoundsService = ref.watch(recentRoundsServiceProvider);
    return StreamBuilder<List<Rounds>>(
      stream: recentRoundsService.roundsStream,
      builder: (context, snapshot) {
        List<String> multipliers = [];
        if (snapshot.hasData) {
          final crashedRounds = snapshot.data!
              .where((round) => round.crashAt != null && round.endedAt != null)
              .toList();
          multipliers = crashedRounds
              .take(15)
              .map((round) => "${round.crashAt}x")
              .toList();
        }
        // If no data, use empty or default, but for now empty
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // first row → 4 chips + button
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < 4 && i < multipliers.length; i++)
                  Expanded(child: _chip(multipliers[i], context)),
                // Button for showing Balance history of the multplier
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => showBalance = !showBalance),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.aviatorTenthColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: AppColors.aviatorEleventhColor),
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
                          color: AppColors.aviatorTertiaryColor,
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          showBalance
                              ? FontAwesomeIcons.angleUp
                              : FontAwesomeIcons.angleDown,
                          size: 16,
                          color: AppColors.aviatorTertiaryColor,
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

/* 

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/aviator/domain/models/rounds.dart';
import 'package:wintek/features/game/aviator/providers/recent_rounds_provider.dart';

class OffersScreen extends ConsumerStatefulWidget {
  const OffersScreen({super.key});

  @override
  ConsumerState<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends ConsumerState<OffersScreen> {
  @override
  void initState() {
    super.initState();
    // Start listening to recent rounds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentRoundsServiceProvider).startListening();
    });
  }

  @override
  void dispose() {
    // Stop listening
    ref.read(recentRoundsServiceProvider).stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recentRoundsService = ref.watch(recentRoundsServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Rounds'),
        backgroundColor: const Color(0xFF140A2D),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => recentRoundsService.fetchRecentRounds(),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF140A2D),
      body: StreamBuilder<List<Rounds>>(
        stream: recentRoundsService.roundsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No recent crashed rounds available'),
            );
          } else {
            final allRounds = snapshot.data!;
            final crashedRounds = allRounds
                .where(
                  (round) => round.crashAt != null && round.endedAt != null,
                )
                .toList();
            if (crashedRounds.isEmpty) {
              return const Center(
                child: Text('No recent crashed rounds available'),
              );
            }
            return ListView.builder(
              itemCount: crashedRounds.length,
              itemBuilder: (context, index) {
                final round = crashedRounds[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: const Color(0xFF271777),
                  child: ListTile(
                    title: Text(
                      'Round ${round.seq} - Crashed at ${round.crashAt}x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Ended At: ${round.endedAt}\nPlayers: ${round.stats.players}, Bets: ${round.stats.bets}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Text(
                      'Max Cashout: ₹${round.stats.maxCashout}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


*/
