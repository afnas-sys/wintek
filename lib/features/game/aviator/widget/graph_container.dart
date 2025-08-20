import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:winket/utils/app_colors.dart';
import 'package:winket/utils/app_images.dart';
import 'package:winket/utils/theme.dart';

class GraphContainer extends StatefulWidget {
  const GraphContainer({super.key});

  @override
  State<GraphContainer> createState() => _GraphContainerState();
}

class _GraphContainerState extends State<GraphContainer> {
  List<FlSpot> points = [
    FlSpot(0, 0),
    FlSpot(1, 0.2),
    FlSpot(2, .8),
    FlSpot(3, 1.8),
    FlSpot(4, 3.2),
    FlSpot(5, 5),
  ];

  @override
  Widget build(BuildContext context) {
    FlSpot peak = points.reduce((a, b) => a.y > b.y ? a : b);

    return Container(
      width: double.infinity,
      height: 294,
      decoration: BoxDecoration(
        color: AppColors.bgSixteenthColor,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(AppImages.graphContainerBgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          // ---------- HEADER ----------
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.bgFifteenthColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                'FUN MODE',
                style: Theme.of(context).textTheme.bodyLargeTitle3Primary,
              ),
            ),
          ),

          // ---------- GRAPH ----------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 8,
                      minY: 0,
                      maxY: 8,

                      // Grid lines
                      gridData: FlGridData(
                        show: false,
                        drawVerticalLine: false,
                        drawHorizontalLine: false,
                        // getDrawingHorizontalLine: (value) =>
                        //     FlLine(color: Colors.white24, strokeWidth: 1),
                        // getDrawingVerticalLine: (value) =>
                        //     FlLine(color: Colors.white24, strokeWidth: 1),
                      ),

                      // Axis titles
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '•',
                                style: const TextStyle(
                                  color: AppColors.graphTextXaxisColor,
                                  fontSize: 16,
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '•',
                                style: const TextStyle(
                                  color: AppColors.graphTextYaxisColor,
                                  fontSize: 16,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),

                      // Border
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.white30),
                      ),

                      // Line data
                      lineBarsData: [
                        LineChartBarData(
                          spots: points,
                          isCurved: true,
                          color: AppColors.graphBarColor,
                          // gradient: const LinearGradient(
                          //   colors: [
                          //     AppColors.graphBarColor,
                          //     AppColors.graphBarColor,

                          //   ],
                          // ),
                          barWidth: 5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.graphBarAreaColor,
                                AppColors.graphBarAreaColor2,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],

                      // Touch interaction
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (spot) => Colors.black87,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                "X:${spot.x}, Y:${spot.y}",
                                const TextStyle(color: Colors.white),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  ),
                  Positioned(
                    left:
                        (peak.x / 8) * (MediaQuery.of(context).size.width - 65),
                    bottom: (peak.y / 8) * (294 - 50 - 10),
                    child: Image.asset(
                      AppImages.graphContainerplaneImage,
                      width: 120,
                      height: 62,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
