import 'dart:math';
import 'package:flutter/material.dart';

class SlotGameOneDirection extends StatefulWidget {
  const SlotGameOneDirection({super.key});

  @override
  State<SlotGameOneDirection> createState() => _SlotGameOneDirectionState();
}

class _SlotGameOneDirectionState extends State<SlotGameOneDirection> {
  final int columns = 5;
  bool isSpinning = false;

  late List<FixedExtentScrollController> controllers;
  late List<int> currentIndex;

  String targetNumber = "";

  // Spin timing configuration
  final int additionalSpin = 70; // how many ticks each reel advances (uniform)
  final int startDelayMs = 300; // delay between starting each reel
  final int baseDurationMs = 1800; // duration for first reel
  final int durationIncrementMs = 300; // extra duration added per reel

  @override
  void initState() {
    super.initState();

    controllers = List.generate(columns, (_) => FixedExtentScrollController());
    currentIndex = List.generate(columns, (_) => 0);

    generateTarget();
  }

  void generateTarget() {
    final r = Random();
    targetNumber = List.generate(5, (_) => r.nextInt(10).toString()).join();
    setState(() {});
  }

  Future<void> spin() async {
    if (isSpinning) return;
    isSpinning = true;
    setState(() {}); // update UI (disable button)

    final r = Random();

    // Start every reel animation (staggered). Update currentIndex immediately so it reflects intended final index.
    for (int i = 0; i < columns; i++) {
      // always spin forward
      int targetDigit = r.nextInt(10);

      // compute final absolute index for this reel (keeps continuity)
      int finalIndex = currentIndex[i] + additionalSpin + targetDigit;
      currentIndex[i] = finalIndex;

      // compute duration for this reel
      final int durationForThisReel =
          baseDurationMs + (i * durationIncrementMs);

      controllers[i].animateToItem(
        finalIndex,
        duration: Duration(milliseconds: durationForThisReel),
        curve: Curves.easeOutQuart,
      );

      // stagger next reel start
      await Future.delayed(Duration(milliseconds: startDelayMs));
    }

    // Calculate maximum finish time to wait for all reels to complete:
    // For reel i: startTime = i * startDelayMs, duration = baseDurationMs + i*durationIncrementMs
    // finishTime_i = startTime + duration
    int maxFinishMs = 0;
    for (int i = 0; i < columns; i++) {
      final int startTime = i * startDelayMs;
      final int durationForThisReel =
          baseDurationMs + (i * durationIncrementMs);
      final int finishTime = startTime + durationForThisReel;
      if (finishTime > maxFinishMs) maxFinishMs = finishTime;
    }

    // Wait a little extra buffer after the last reel finishes
    await Future.delayed(Duration(milliseconds: maxFinishMs + 120));

    // Now it's safe — read the center-row result from currentIndex (no timing race)
    checkResult();

    isSpinning = false;
    setState(() {}); // re-enable button
  }

  void checkResult() {
    List<int> result = [];

    for (int i = 0; i < columns; i++) {
      int centerDigit = currentIndex[i] % 10;
      result.add(centerDigit);
    }

    String resultString = result.join();

    // Count how many times each digit appears
    Map<int, int> freq = {};
    for (var n in result) {
      freq[n] = (freq[n] ?? 0) + 1;
    }

    int maxCount = freq.values.reduce(max);

    String status = "";
    Color color = Colors.red;
    IconData icon = Icons.cancel;

    if (maxCount == 5) {
      status = "🏆 EXCELLENT!";
      color = Colors.amber;
      icon = Icons.star;
    } else if (maxCount == 4) {
      status = "🔥 BETTER!";
      color = Colors.orange;
      icon = Icons.whatshot;
    } else if (maxCount == 3) {
      status = "👍 GOOD!";
      color = Colors.green;
      icon = Icons.thumb_up;
    } else {
      status = "❌ TRY AGAIN!";
      color = Colors.red;
      icon = Icons.cancel;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 60),
              SizedBox(height: 10),
              Text(
                status,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: 10),
              Text("Result: $resultString", style: TextStyle(fontSize: 22)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                ),
                child: Text("OK", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildReel(int columnIndex) {
    return SizedBox(
      width: 60,
      height: 210,
      child: ListWheelScrollView.useDelegate(
        controller: controllers[columnIndex],
        physics: const FixedExtentScrollPhysics(),
        itemExtent: 70,
        perspective: 0.0001, // no 3D distortion
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (_, index) {
            int number = index % 10;
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0XFF484c54),
                    Color(0XFF191a21),
                    Color(0XFF484c54),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(12),
                // border: Border.all(color: Colors.white, width: 2),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    LinearGradient(
                      colors: [Colors.red, Colors.yellow, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                child: Text(
                  "$number",
                  style: const TextStyle(
                    fontSize: 38,
                    color: Colors.white, // required but ignored
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // reels
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(columns, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: buildReel(i),
                );
              }),
            ),
          ),

          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: isSpinning ? null : spin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 60),
            ),
            child: Text(
              isSpinning ? "SPINNING..." : "SPIN",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
