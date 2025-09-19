import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/game/aviator/providers/aviator_provider.dart';

class GraphContainer extends ConsumerWidget {
  const GraphContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final round = ref.watch(aviatorProvider);

    final points = ref.watch(aviatorGraphProvider);
    FlSpot peak = points.isNotEmpty
        ? points.reduce((a, b) => a.y > b.y ? a : b)
        : const FlSpot(0, 0);

    return Container(
      width: double.infinity,
      height: 294,
      decoration: BoxDecoration(
        color: AppColors.aviatorTwelfthColor,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(AppImages.graphContainerBgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          //! HEADER
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.aviatorThirteenthColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                'FUN MODE',
                style: Theme.of(context).textTheme.aviatorBodyTitleMdeium,
              ),
            ),
          ),

          //! GRAPH
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: (points.isNotEmpty ? points.last.x : 10) + 2,
                      minY: 0,
                      maxY: (peak.y + 1).clamp(5, 100),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                "•",
                                style: const TextStyle(
                                  color: AppColors.aviatorGraphYaxisColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '•',
                                style: const TextStyle(
                                  color: AppColors.aviatorGraphXaxisColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: AppColors.aviatorGraphBorderColor,
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 0), // force starting from origin
                            ...points,
                          ],
                          isCurved: true,
                          color: AppColors.aviatorGraphBarColor,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: false,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                  radius: 3,
                                  color: AppColors.aviatorGraphBarColor,
                                  strokeWidth: 1,
                                  // strokeColor: Colors.white,
                                ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.aviatorGraphBarAreaColor1,
                                AppColors.aviatorGraphBarAreaColor2,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //! Multiplier in center
                  Center(
                    child: Text(
                      points.isNotEmpty
                          ? "${points.last.y.toStringAsFixed(2)}X"
                          : "0.00X",
                      style: Theme.of(context).textTheme.aviatorDisplayLarge,
                    ),
                  ),

                  //! Plane at peak
                  if (points.isNotEmpty)
                    Positioned(
                      left:
                          (peak.x / (points.last.x + 2)) *
                          (MediaQuery.of(context).size.width - 60),
                      bottom: (peak.y / (peak.y + 5)) * (294 - 69),
                      child: Image.asset(
                        AppImages.graphContainerplaneImage,
                        width: 80,
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
