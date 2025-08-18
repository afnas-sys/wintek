import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class dummy extends StatefulWidget {
  const dummy({Key? key}) : super(key: key);

  @override
  State<dummy> createState() => _AviatorGameScreenState();
}

class _AviatorGameScreenState extends State<dummy>
    with SingleTickerProviderStateMixin {
  double multiplier = 1.0;
  List<FlSpot> points = [FlSpot(0, 1)];
  Timer? _timer;
  double xValue = 0;
  final Random random = Random();

  // Dummy bet data
  List<Map<String, dynamic>> dummyBets = [
    {"user": "d***3", "bet": 100, "mult": 2.57, "cashout": 257},
    {"user": "d***8", "bet": 50, "mult": 1.76, "cashout": 88},
    {"user": "d***9", "bet": 200, "mult": 3.12, "cashout": 624},
  ];

  // Dummy history multipliers
  List<double> historyMultipliers = [1.02, 3.52, 4.87, 27.76, 1.07];

  @override
  void initState() {
    super.initState();
    _startFakeGraph();
  }

  void _startFakeGraph() {
    _timer?.cancel();
    xValue = 0;
    multiplier = 1.0;
    points = [FlSpot(0, 1)];

    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        xValue += 0.2;
        multiplier += 0.05 + random.nextDouble() * 0.1;
        points.add(FlSpot(xValue, multiplier));
      });

      if (multiplier > 20) {
        timer.cancel(); // Stop graph at 20x (fake end)
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      body: SafeArea(
        child: Column(
          children: [
            _buildBalanceHeader(),
            _buildHistoryChips(),
            Expanded(child: _buildGraphArea()),
            _buildBetPanels(),
            Expanded(child: _buildBetsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Available balance: ₹0.00",
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Withdraw"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Deposit"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: historyMultipliers
            .map((m) => Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("${m.toStringAsFixed(2)}x",
                      style: const TextStyle(color: Colors.white)),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildGraphArea() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: points,
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
          Text(
            "${multiplier.toStringAsFixed(2)}X",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBetPanels() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(child: _betPanel("Bet")),
          const SizedBox(width: 12),
          Expanded(child: _betPanel("Auto")),
        ],
      ),
    );
  }

  Widget _betPanel(String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text("1.00",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size.fromHeight(45),
            ),
            child: const Text("BET"),
          ),
        ],
      ),
    );
  }

  Widget _buildBetsList() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text("TOTAL BETS", style: TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: dummyBets.length,
              itemBuilder: (context, index) {
                final bet = dummyBets[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(bet['user'],
                          style: const TextStyle(color: Colors.white)),
                      Text("₹${bet['bet']}",
                          style: const TextStyle(color: Colors.white70)),
                      Text("${bet['mult']}x",
                          style: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold)),
                      Text("₹${bet['cashout']}",
                          style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
