import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wintek/utils/app_colors.dart';
import 'package:wintek/utils/app_images.dart';
import 'package:wintek/utils/theme.dart';

class GraphContainer extends StatefulWidget {
  const GraphContainer({super.key});

  @override
  State<GraphContainer> createState() => _GraphContainerState();
}

class _GraphContainerState extends State<GraphContainer>
    with SingleTickerProviderStateMixin {
  List<FlSpot> points = [
    FlSpot(0, 0),
    FlSpot(1, 0.2),
    FlSpot(2, .8),
    FlSpot(3, 1.8),
    FlSpot(4, 3.2),
    FlSpot(5, 5),
    FlSpot(6, 6),
    FlSpot(7, 7),
    FlSpot(8, 8),
    FlSpot(9, 9),
    FlSpot(10, 10),
  ];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), // animation time
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        // Interpolate points based on animation progress
        final int lastIndex = (_animation.value * (points.length - 1)).floor();
        final double t = (_animation.value * (points.length - 1)) - lastIndex;

        List<FlSpot> visibleSpots = [];
        if (lastIndex >= 0) {
          visibleSpots = points.sublist(0, lastIndex + 1);

          // Add an in-between spot for smooth animation
          if (lastIndex < points.length - 1) {
            final FlSpot p1 = points[lastIndex];
            final FlSpot p2 = points[lastIndex + 1];
            final FlSpot interpolated = FlSpot(
              p1.x + (p2.x - p1.x) * t,
              p1.y + (p2.y - p1.y) * t,
            );
            visibleSpots.add(interpolated);
          }
        }

        FlSpot peak = visibleSpots.isNotEmpty
            ? visibleSpots.reduce((a, b) => a.y > b.y ? a : b)
            : FlSpot(0, 0);

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
                      //! Graph
                      LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 10,
                          minY: 0,
                          maxY: 10,
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            show: true,
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '•',
                                    style: const TextStyle(
                                      color: AppColors.aviatorGraphYaxisColor,
                                      fontSize: 20,
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
                                      fontSize: 20,
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
                              spots: visibleSpots,
                              isCurved: true,
                              color: AppColors.aviatorGraphBarColor,
                              barWidth: 5,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: false),
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

                      //! Gradient text in center
                      Center(
                        child: Text(
                          "1.16X",
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorDisplayLarge,
                        ),
                      ),

                      //! Plane at peak
                      if (visibleSpots.isNotEmpty)
                        Positioned(
                          left:
                              (peak.x / 8) *
                              (MediaQuery.of(context).size.width - 90),
                          bottom: (peak.y / 8) * (294 - 69 - 10),
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
      },
    );
  }
}
