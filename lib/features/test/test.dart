import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/aviator/domain/models/get_bet_user_model.dart';
import 'package:wintek/features/game/aviator/providers/bet_history_provider.dart';

class Test extends ConsumerStatefulWidget {
  const Test({super.key});

  @override
  ConsumerState<Test> createState() => _TestState();
}

class _TestState extends ConsumerState<Test> {
  @override
  void initState() {
    super.initState();
    // Fetch bet history on init, assuming userId is 'someUserId'
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(betHistoryProvider.notifier).fetchBetHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final betHistoryAsync = ref.watch(betHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bet History')),
      body: betHistoryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (betHistory) {
          if (betHistory == null || betHistory.data.isEmpty) {
            return const Center(
              child: Text(
                'No bets found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            itemCount: betHistory.data.length,
            itemBuilder: (context, index) {
              final bet = betHistory.data[index];

              // Helper function to format numbers safely
              String formatNum(num? value) =>
                  value?.toStringAsFixed(2) ?? '0.00';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'id: ${bet.id}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Status: ${(bet.status)} ',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Stake: ${formatNum(bet.stake)} ${bet.currency}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Auto Cashout: ${formatNum(bet.autoCashout)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Crash At: ${formatNum(bet.roundId.crashAt)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Payout: ${formatNum(bet.payout)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'User Name: ${(bet.user.userName)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        // Text(
                        //   'Cashed Out At: ${bet.cashedOutAt != null ? formatNum(bet.cashedOutAt) : 'N/A'}',
                        //   style: const TextStyle(color: Colors.white),
                        // ),
                        // const SizedBox(height: 4),
                        // Text(
                        //   'Multiplier: ${formatNum(bet.multiplier)}x',
                        //   style: const TextStyle(color: Colors.white),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
