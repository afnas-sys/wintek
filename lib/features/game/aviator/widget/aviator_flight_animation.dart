import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/game/aviator/providers/aviator_round_provider.dart';

class AviatorFlightAnimation extends ConsumerStatefulWidget {
  const AviatorFlightAnimation({super.key});

  @override
  ConsumerState<AviatorFlightAnimation> createState() =>
      _AnimatedContainerState();
}

class _AnimatedContainerState extends ConsumerState<AviatorFlightAnimation>
    with TickerProviderStateMixin {
  late AnimationController _takeoffController;
  late AnimationController _waveController;
  late AnimationController _flyAwayController;

  late Animation<double> _takeoffAnimation;
  late Animation<double> _flyAwayAnimation;

  bool _isWaving = false;
  bool _isAnimating = false;

  bool _hasReachedWave = false;
  bool _hasFlownAway = false;

  final List<Offset> _pathPoints = [];
  Offset? _currentPlanePosition;

  double _waveProgress = 0.0;
  final double _waveAmplitude = 15.0;
  final double _waveFrequency = 0.05;

  // 👈 PREPARE state countdown variables
  int _prepareSecondsLeft = 0;
  int _initialPrepareSeconds = 0;
  double _prepareProgress = 1.0;
  Timer? _prepareTimer;

  @override
  void initState() {
    super.initState();

    _takeoffController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _takeoffAnimation = CurvedAnimation(
      parent: _takeoffController,
      curve: Curves.easeInOutCubic,
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );

    double lastWaveTick = 0.0;

    _waveController.addListener(() {
      if (_isWaving) {
        final now =
            _waveController.lastElapsedDuration?.inMilliseconds.toDouble() ??
            0.0;
        final delta = now - lastWaveTick;
        lastWaveTick = now;

        const speed = 0.02;
        setState(() {
          _waveProgress += delta * speed;
        });
      }
    });

    _flyAwayController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    _flyAwayAnimation = CurvedAnimation(
      parent: _flyAwayController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _takeoffController.dispose();
    _waveController.dispose();
    _flyAwayController.dispose();
    _prepareTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final round = ref.watch(aviatorRoundNotifierProvider);
    final tick = ref.watch(aviatorTickProvider);

    // 👇 Detect if socket is connecting (no data yet)
    final isSocketConnecting =
        round == null || tick.isLoading || tick.value == null;

    if (isSocketConnecting) {
      // 🛫 Initial loader + plane
      return Container(
        width: double.infinity,
        height: 294,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Plane at (0,0)
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(AppImages.graphContainerplaneImage, width: 70),
            ),

            // Circular progress indicator
            const CircularProgressIndicator(
              color: AppColors.aviatorTwentyEighthColor,
              strokeWidth: 3,
            ),
          ],
        ),
      );
    }

    // PREPARE countdown logic
    if (round.state == 'PREPARE') {
      final msRemaining = int.tryParse(round.msRemaining ?? '0') ?? 0;
      final secondsRemaining = (msRemaining / 1000).ceil();
      if (_initialPrepareSeconds != secondsRemaining && secondsRemaining > 0) {
        _initialPrepareSeconds = secondsRemaining;
        _prepareSecondsLeft = secondsRemaining;
        _prepareProgress = 1.0;
        if (_prepareTimer == null) _startPrepareCountdown();
      }
    } else {
      _prepareTimer?.cancel();
      _prepareTimer = null;
      _prepareSecondsLeft = 0;
      _initialPrepareSeconds = 0;
      _prepareProgress = 1.0;
    }

    // RUNNING and CRASHED triggers
    if (round.state == 'RUNNING' && !_isAnimating) _startTakeoff();
    if (round.state == 'CRASHED' && !_hasFlownAway) _startFlyAway();

    // Current multiplier
    final currentValue = tick.when(
      data: (data) => double.tryParse(data.multiplier ?? '0') ?? 0.0,
      error: (_, _) => 0.0,
      loading: () => 0.0,
    );

    return Container(
      width: double.infinity,
      height: 294,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Top bar
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

          // PREPARE UI
          if (round.state == 'PREPARE')
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: _prepareProgress),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, value, child) {
                        return Container(
                          width: 200, // adjust width as needed
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white24, // background track
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: value, // controls fill percentage
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors
                                    .aviatorGraphBarColor, // active color
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 50),
                        //! 20s center text
                        // Text(
                        //   "$_prepareSecondsLeft",
                        //   style: Theme.of(
                        //     context,
                        //   ).textTheme.aviatorDisplayLarge,
                        // ),
                        const SizedBox(height: 28),
                        Text(
                          "Next round starts",
                          style: Theme.of(
                            context,
                          ).textTheme.aviatorBodyTitleMdeium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            // RUNNING / CRASHED UI
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final height = constraints.maxHeight;

                  return AnimatedBuilder(
                    animation: Listenable.merge([
                      _takeoffController,
                      _waveController,
                      _flyAwayController,
                    ]),
                    builder: (context, _) {
                      double x, y;
                      double planeAngle = -pi / 12;

                      if (_flyAwayController.isAnimating) {
                        final t = _flyAwayAnimation.value;
                        final start = Offset(width * 0.65, height * 0.5);
                        final control = Offset(width * 0.85, height * 0.8);
                        final end = Offset(width * 1.2, height + 150);
                        x =
                            (1 - t) * (1 - t) * start.dx +
                            2 * (1 - t) * t * control.dx +
                            t * t * end.dx;
                        y =
                            (1 - t) * (1 - t) * start.dy +
                            2 * (1 - t) * t * control.dy +
                            t * t * end.dy;
                        planeAngle = -pi / 6;
                      } else {
                        final t = _takeoffAnimation.value;
                        final start = Offset(0, 0);
                        final control = Offset(width * 0.45, height * 0.1);
                        final end = Offset(width * 0.65, height * 0.5);

                        x =
                            (1 - t) * (1 - t) * start.dx +
                            2 * (1 - t) * t * control.dx +
                            t * t * end.dx;
                        y =
                            (1 - t) * (1 - t) * start.dy +
                            2 * (1 - t) * t * control.dy +
                            t * t * end.dy;

                        if (!_hasReachedWave && t >= 1) {
                          _hasReachedWave = true;
                          _isWaving = true;
                          _takeoffController.stop();
                          _waveController.repeat();
                        }
                      }

                      double waveOffset = 0.0;
                      if (_isWaving && !_flyAwayController.isAnimating) {
                        waveOffset =
                            sin(_waveProgress * _waveFrequency) *
                            _waveAmplitude;
                        final waveTangent =
                            cos(_waveProgress * _waveFrequency) *
                            _waveAmplitude *
                            _waveFrequency;
                        planeAngle = -atan(waveTangent / 5);
                      }

                      final bottomPos = (y + waveOffset)
                          .clamp(0, height - 60)
                          .toDouble();
                      final currentPoint = Offset(
                        x.clamp(0, width - 80),
                        height - bottomPos,
                      );
                      _currentPlanePosition = currentPoint;

                      if (_isAnimating &&
                          !_flyAwayController.isAnimating &&
                          !_isWaving) {
                        if (_pathPoints.isEmpty ||
                            (_pathPoints.last - currentPoint).distance > 1) {
                          _pathPoints.add(currentPoint);
                        }
                      }

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CustomPaint(
                            size: Size(width, height),
                            painter: PathPainter(
                              _pathPoints,
                              height,
                              _currentPlanePosition,
                              _isWaving,
                              _waveProgress,
                              _waveAmplitude,
                              _waveFrequency,
                            ),
                          ),
                          Positioned(
                            left: currentPoint.dx,
                            bottom: bottomPos,
                            child: Transform.rotate(
                              angle: planeAngle,
                              child: Image.asset(
                                AppImages.graphContainerplaneImage,
                                width: 70,
                              ),
                            ),
                          ),
                          if (round.state == 'RUNNING')
                            Center(
                              child: Text(
                                "${currentValue.toStringAsFixed(2)}x",
                                style: Theme.of(
                                  context,
                                ).textTheme.aviatorDisplayLarge,
                              ),
                            ),
                          if (round.state == 'CRASHED' &&
                              _flyAwayController.isAnimating)
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "FLEW AWAY",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.aviatorHeadlineSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${round.crashAt.toString()}x",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.aviatorDisplayLargeSecond,
                                    // ),
                                    // Text(
                                    //   ' ${round.crashAt.toString()}',
                                    //   style: Theme.of(
                                    //     context,
                                    //   ).textTheme.aviatorHeadlineSmall,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // PREPARE countdown
  void _startPrepareCountdown() {
    _prepareTimer?.cancel();

    _prepareTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_prepareSecondsLeft <= 1) {
        timer.cancel();
        _prepareTimer = null;
        setState(() {
          _prepareSecondsLeft = 0;
          _prepareProgress = 0.0;
        });
      } else {
        setState(() {
          _prepareSecondsLeft--;
          _prepareProgress = _prepareSecondsLeft / _initialPrepareSeconds;
        });
      }
    });
  }

  void _startTakeoff() {
    _isAnimating = true;
    _hasReachedWave = false;
    _isWaving = false;
    _hasFlownAway = false;
    _waveProgress = 0.0;
    _pathPoints.clear();
    _currentPlanePosition = null;
    _takeoffController.forward(from: 0);
  }

  void _startFlyAway() {
    _hasFlownAway = true;
    _isWaving = false;
    _waveController.stop();
    _pathPoints.clear();
    _currentPlanePosition = null;
    _flyAwayController.forward(from: 0).whenComplete(() => _resetAnimation());
  }

  void _resetAnimation() {
    _isAnimating = false;
    _isWaving = false;
    _hasReachedWave = false;
    _hasFlownAway = false;
    _waveProgress = 0.0;
    _pathPoints.clear();
    _currentPlanePosition = null;

    _takeoffController.reset();
    _waveController.reset();
    _flyAwayController.reset();
  }
}

class PathPainter extends CustomPainter {
  final List<Offset> points;
  final double height;
  final Offset? currentPlanePosition;
  final bool isWaving;
  final double waveProgress;
  final double waveAmplitude;
  final double waveFrequency;

  PathPainter(
    this.points,
    this.height,
    this.currentPlanePosition,
    this.isWaving,
    this.waveProgress,
    this.waveAmplitude,
    this.waveFrequency,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    List<Offset> displayPoints;

    if (isWaving && currentPlanePosition != null) {
      displayPoints = [...points];

      final startX = points.last.dx;
      final endX = currentPlanePosition!.dx;
      final baseY = points.last.dy;

      final distance = endX - startX;
      final numWavePoints = max(20, (distance / 5).round());

      for (int i = 0; i <= numWavePoints; i++) {
        final t = i / numWavePoints;
        final x = startX + (distance * t);
        final wavePhase = waveProgress - ((endX - x) / 5);
        final waveY = sin(wavePhase * waveFrequency) * waveAmplitude;
        displayPoints.add(Offset(x, baseY - waveY));
      }
    } else {
      displayPoints = points;
    }

    if (displayPoints.isEmpty) return;

    final fillPaint = Paint()
      ..color = const Color.fromARGB(255, 128, 121, 121).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final fillPath = Path()
      ..moveTo(displayPoints.first.dx, displayPoints.first.dy);
    _drawSmoothCurve(fillPath, displayPoints);
    fillPath.lineTo(displayPoints.last.dx, height);
    fillPath.lineTo(displayPoints.first.dx, height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    final pathPaint = Paint()
      ..color = AppColors.aviatorGraphBarColor
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(displayPoints.first.dx, displayPoints.first.dy);
    _drawSmoothCurve(path, displayPoints);
    canvas.drawPath(path, pathPaint);

    final xAxisPaint = Paint()
      ..color = AppColors.aviatorGraphBarAreaColor2
      ..style = PaintingStyle.fill;

    for (int i = 1; i < displayPoints.length; i++) {
      final prev = displayPoints[i - 1];
      final curr = displayPoints[i];
      final rect = Rect.fromLTRB(prev.dx, curr.dy, curr.dx, height);
      canvas.drawRect(rect, xAxisPaint);
    }
  }

  void _drawSmoothCurve(Path path, List<Offset> points) {
    if (points.length < 2) return;

    for (int i = 1; i < points.length; i++) {
      final p1 = points[i];
      if (i == points.length - 1) {
        path.lineTo(p1.dx, p1.dy);
      } else {
        final p2 = points[i + 1];
        final controlPoint = Offset(p1.dx, p1.dy);
        final endPoint = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
        path.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          endPoint.dx,
          endPoint.dy,
        );
      }
    }
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.currentPlanePosition != currentPlanePosition ||
      oldDelegate.isWaving != isWaving ||
      oldDelegate.waveProgress != waveProgress;
}
