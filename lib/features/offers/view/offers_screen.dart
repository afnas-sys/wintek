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
