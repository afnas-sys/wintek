import 'dart:math';
import 'package:flutter/material.dart';

enum RowType { top, center, bottom }

class SpinToWinGame extends StatefulWidget {
  const SpinToWinGame({super.key});

  @override
  State<SpinToWinGame> createState() => SpinToWinGameState();
}

class SpinToWinGameState extends State<SpinToWinGame> {
  final int columns = 5;
  bool isSpinning = false;

  late List<FixedExtentScrollController> controllers;
  late List<int> currentIndex;
  late List<int> digits;

  // Spin timing configuration
  late final int additionalSpin =
      70; // how many ticks each reel advances (uniform)
  late final int startDelayMs = 300; // delay between starting each reel
  late final int baseDurationMs = 1800; // duration for first reel
  late final int durationIncrementMs = 300; // extra duration added per reel

  @override
  void initState() {
    super.initState();

    // repeated digits to simulate a long wheel
    digits = List.generate(1000, (index) => index % 10);

    controllers = List.generate(
      columns,
      (_) => FixedExtentScrollController(initialItem: 500),
    );
    currentIndex = List.generate(columns, (_) => 500);
  }

  Future<void> spin() async {
    if (isSpinning) return;
    isSpinning = true;
    setState(() {});

    final r = Random();

    for (int i = 0; i < columns; i++) {
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

    checkResult();

    isSpinning = false;
    setState(() {});
  }

  void checkResult() {
    List<int> result = [];

    for (int i = 0; i < columns; i++) {
      int centerDigit = currentIndex[i] % 10;
      result.add(centerDigit);
    }
  }

  // Build the digit widget with different bg based on row type
  Widget buildDigitItem(int digit, {RowType rowType = RowType.center}) {
    Color bg;

    if (rowType == RowType.top) {
      bg = Colors.white.withAlpha(70); // top row color
    } else if (rowType == RowType.bottom) {
      bg = Colors.white.withAlpha(70); // bottom row color
    } else {
      bg = Colors.white; // center row color
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      height: 76,

      alignment: Alignment.center,
      child: Container(
        height: 58,
        width: 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          digit.toString(),
          style: const TextStyle(
            fontSize: 38,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildReel(int columnIndex) {
    return Container(
      width: 70,
      height: 222,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/reel_bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.2),
      ),
      child: ListWheelScrollView.useDelegate(
        controller: controllers[columnIndex],
        itemExtent: 76,
        physics: const NeverScrollableScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            // guard: index must be within digits length
            if (index < 0 || index >= digits.length) {
              return const SizedBox.shrink();
            }

            // selectedItem gives the currently centered item index
            final selected = controllers[columnIndex].selectedItem;

            final offset = index - selected;

            RowType rowType;
            if (offset == 0) {
              rowType = RowType.center;
            } else if (offset == -1) {
              rowType = RowType.top;
            } else if (offset == 1) {
              rowType = RowType.bottom;
            } else {
              rowType = RowType.center; // non-visible items: keep default
            }

            return buildDigitItem(digits[index], rowType: rowType);
          },
          childCount: digits.length,
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
          SizedBox(
            height: 274,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 274,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/spin_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 274,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 26,
                  ),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/spintowin_frame.png'),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: List.generate(columns, (i) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: buildReel(i),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
