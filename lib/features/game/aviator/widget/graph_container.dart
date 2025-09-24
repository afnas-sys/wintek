import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/game/aviator/providers/aviator_round_provider.dart';

class GraphContainer extends ConsumerWidget {
  const GraphContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final state = ref.watch(aviatorStateProvider);
    final tick = ref.watch(aviatorTickProvider);
    final crash = ref.watch(aviatorCrashProvider);
    final round = ref.watch(aviatorRoundNotifierProvider);
    //final round = ref.watch(aviatorProvider);

    final points = tick.when(
      data: (data) {
        double value = double.tryParse(data.multiplier.toString()) ?? 0.0;
        double x = value - 1;
        double y = value - 1;
        return <FlSpot>[FlSpot(x, y)]; // explicitly typed
      },
      error: (error, stackTrace) => <FlSpot>[],
      loading: () => <FlSpot>[],
    );

    final currentValue = tick.when(
      data: (data) => double.tryParse(data.multiplier ?? '0') ?? 0.0,
      error: (_, _) => 0.0,
      loading: () => 0.0,
    );

    FlSpot peak = points.isNotEmpty
        ? points.reduce((FlSpot a, FlSpot b) => a.y > b.y ? a : b)
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
          //! Graph
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Builder(
                builder: (_) {
                  if (round == null) {
                    return Center(
                      child: Lottie.asset(AppImages.aviatorloading),
                    );
                  }

                  switch (round.state) {
                    case "PREPARE":
                      return Center(
                        child: Column(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitWaveSpinner(
                              color: AppColors.aviatorGraphBarColor,
                            ),
                            Text(
                              "Waiting for next round...",
                              style: Theme.of(
                                context,
                              ).textTheme.aviatorHeadlineSmall,
                            ),
                          ],
                        ),
                      );
                    // inside switch (round.state)
                    case "RUNNING":
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Lottie.asset(
                              AppImages.aviatorbg, // your lottie file path
                              fit: BoxFit.fill,
                              repeat: true,
                            ),
                          ),

                          /// Graph chart + UI
                          LineChart(
                            LineChartData(
                              minX: 0,
                              maxX:
                                  (points.isNotEmpty ? points.last.x : 10) + 2,
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
                                      return const Text(
                                        "•",
                                        style: TextStyle(
                                          color:
                                              AppColors.aviatorGraphYaxisColor,
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
                                      return const Text(
                                        '•',
                                        style: TextStyle(
                                          color:
                                              AppColors.aviatorGraphXaxisColor,
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
                                  spots: [FlSpot(0, 0), ...points],
                                  isCurved: true,
                                  color: AppColors.aviatorGraphBarColor,
                                  barWidth: 4,
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

                          /// Multiplier in center
                          Center(
                            child: Text(
                              "${currentValue.toStringAsFixed(2)}X",
                              style: Theme.of(
                                context,
                              ).textTheme.aviatorDisplayLarge,
                            ),
                          ),

                          /// Plane at peak
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
                      );

                    case "CRASHED":
                      return Center(
                        child: Text(
                          "Cashed out at ${currentValue.toStringAsFixed(2)}X",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 245, 248, 247),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );

                    default:
                      return const Center(child: Text("Unknown state"));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
