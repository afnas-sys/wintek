import 'package:flutter/material.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/core/constants/app_strings.dart';
import 'package:wintek/core/constants/app_colors.dart';

class BottumHistoryTab extends StatefulWidget {
  const BottumHistoryTab({super.key});

  @override
  State<BottumHistoryTab> createState() => _BottumHistoryTabState();
}

class _BottumHistoryTabState extends State<BottumHistoryTab> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Buttons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: _buildButton(0, AppStrings.historyFirstButtonName)),
            SizedBox(width: 15),
            Expanded(
              child: _buildButton(1, AppStrings.historySecondButtonName),
            ),
          ],
        ),

        const SizedBox(height: 20),
        if (selectedIndex == 0)
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.cardPrimaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Period',
                  // fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                AppText(
                  text: 'Result',
                  // fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        // ListView changes based on button
        // HistoryListSection(isGameHistory: selectedIndex == 0),
      ],
    );
  }

  Widget _buildButton(int index, String text) {
    final isSelected = selectedIndex == index;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        backgroundColor: isSelected
            ? AppColors.cardPrimaryColor
            : Colors.grey[300],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AppText(text: text, fontSize: 16, fontWeight: FontWeight.w500),
    );
  }
}
