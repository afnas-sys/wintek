import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/game/aviator/providers/top_bets_provider.dart';

class Test extends ConsumerStatefulWidget {
  const Test({super.key});

  @override
  ConsumerState<Test> createState() => _TestState();
}

class _TestState extends ConsumerState<Test> {
  @override
  void initState() {
    super.initState();
    // Fetch top bets on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(topBetsProvider.notifier).fetchTopBets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topBetsAsync = ref.watch(topBetsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Top Bets')),
      body: topBetsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (topBetsModel) {
          if (topBetsModel == null || topBetsModel.data.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          return ListView.builder(
            itemCount: topBetsModel.data.length,
            itemBuilder: (context, index) {
              final bet = topBetsModel.data[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('id: ${bet.id}'),
                      Text('Stake: ${bet.stake}'),
                      Text('Currency: ${bet.currency}'),
                      Text('Auto Cashout: ${bet.autoCashout}'),
                      Text('bet index: ${bet.betIndex}'),
                      Text('Placed At: ${bet.placedAt}'),
                      Text('cashout At: ${bet.cashoutAt}'),
                      if (bet.cashedOutAt != null)
                        Text('Cashed Out At: ${bet.cashedOutAt}'),
                      Text('Payout: ${bet.payout}'),
                      Text('Status: ${bet.status}'),
                      Text('Created At: ${bet.createdAt}'),
                      Text('Updated At: ${bet.updatedAt}'),

                      SizedBox(height: 20),
                      Text('Round Id: ${bet.roundId?.id}'),
                      Text('Seq: ${bet.roundId?.seq}'),
                      Text('State: ${bet.roundId?.state}'),
                      Text('Started At: ${bet.roundId?.startedAt}'),
                      Text('Crash At: ${bet.roundId?.crashAt}'),
                      Text('Ended At: ${bet.roundId?.endedAt}'),

                      SizedBox(height: 20),
                      Text('User Id: ${bet.userId?.id}'),
                      Text(
                        'User: ${bet.userId?.userName ?? 'Unknown'}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('email: ${bet.userId?.email}'),
                    ],
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
