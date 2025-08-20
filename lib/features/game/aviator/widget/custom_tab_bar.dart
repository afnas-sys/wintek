import 'package:flutter/material.dart';
import 'package:winket/utils/app_colors.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> tabViews; 
  final Color backgroundColor;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color selectedTabColor;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.tabViews,
    this.backgroundColor = AppColors.bgSeventeenthColor,
    this.borderRadius = 16,
    this.borderWidth = 1,
    this.borderColor = AppColors.borderSecondaryColor,
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = Colors.black,
    this.selectedTabColor = Colors.blue,
  }) : assert(tabs.length == tabViews.length, "tabs and tabViews must have same length");

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// ---- Custom Tab Buttons ----
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
          child: Row(
            children: List.generate(widget.tabs.length, (index) {
              final bool isSelected = selectedIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? widget.selectedTabColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.tabs[index],
                      style: TextStyle(
                        color: isSelected
                            ? widget.selectedTextColor
                            : widget.unselectedTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 16),

        widget.tabViews[selectedIndex],
      ],
    );
  }
}
