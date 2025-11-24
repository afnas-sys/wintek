import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
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
  late AnimationController _enterController;

  late Animation<double> _takeoffAnimation;
  late Animation<double> _flyAwayAnimation;

  bool _isWaving = false;
  bool _isAnimating = false;

  bool _hasReachedWave = false;
  bool _hasFlownAway = false;

  final List<Offset> _pathPoints = [];
  Offset? _currentPlanePosition;
  Offset? _flyAwayStartPosition;

  double _waveProgress = 0.0;
  final double _waveAmplitude = 15.0;
  final double _waveFrequency = 0.05;

  // 👈 PREPARE state countdown variables
  int _prepareSecondsLeft = 0;
  int _initialPrepareSeconds = 0;
  double _prepareProgress = 1.0;
  Timer? _prepareTimer;
  late final AnimationController _controller;
  bool _isControllerRepeating = false;

  // Your image size (must match actual image OR container you use)
  final double imgWidth = 396;
  final double imgHeight = 294;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 120),
      vsync: this,
    );

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
      duration: const Duration(milliseconds: 2500),
    );
    _flyAwayAnimation = CurvedAnimation(
      parent: _flyAwayController,
      curve: Curves.easeInOutCubic,
    );

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _takeoffController.dispose();
    _waveController.dispose();
    _flyAwayController.dispose();
    _enterController.dispose();
    _prepareTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final round = ref.watch(aviatorRoundNotifierProvider);
    final tick = ref.watch(aviatorTickProvider);

    // Determine if we already have any tick data
    final hasTickData = tick.maybeWhen(data: (_) => true, orElse: () => false);

    // Control the background animation controller based on tick data
    if (hasTickData && !_isControllerRepeating) {
      _controller.repeat(period: const Duration(seconds: 12));
      _isControllerRepeating = true;
    } else if (!hasTickData && _isControllerRepeating) {
      _controller.stop();
      _isControllerRepeating = false;
    }

    // 👇 Detect if socket is connecting (no data yet)
    // Consider it "connected" as soon as either round state or tick arrives
    final isSocketConnecting = round == null && !hasTickData;

    if (isSocketConnecting) {
      // 🛫 Initial loader + plane
      return Container(
        width: double.infinity,
        height: 294,
        decoration: const BoxDecoration(
          color: Color(0XFF271777),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Lottie.asset(
              'assets/images/aviator_loading.json',
              width: 150,
              height: 150,
            ),
            // Plane at (0,0)

            // Positioned(
            //   left: 0,
            //   bottom: 0,
            //   child: Image.asset(AppImages.graphContainerplaneImage, width: 70),
            // ),

            // // Circular progress indicator
            // const CircularProgressIndicator(
            //   color: AppColors.aviatorTwentyEighthColor,
            //   strokeWidth: 3,
            // ),
          ],
        ),
      );
    }

    // PREPARE countdown logic
    if (round?.state == 'PREPARE') {
      final msRemaining = int.tryParse(round?.msRemaining ?? '0') ?? 0;
      final secondsRemaining = (msRemaining / 1000).ceil();
      if (_initialPrepareSeconds != secondsRemaining && secondsRemaining > 0) {
        _initialPrepareSeconds = secondsRemaining;
        _prepareSecondsLeft = secondsRemaining;
        _prepareProgress = 1.0;
        if (_prepareTimer == null) _startPrepareCountdown();
      }

      // When we enter PREPARE after a CRASHED round / fly-away,
      // ensure all animation state is reset exactly once here,
      // instead of from the fly-away controller callback. This
      // avoids wiping the new round's path if a new takeoff starts
      // before the previous fly-away animation completes.
      if (_isAnimating ||
          _hasFlownAway ||
          _takeoffController.isAnimating ||
          _flyAwayController.isAnimating ||
          _waveController.isAnimating) {
        _resetAnimation();
      }

      // Stop the background animation in PREPARE state
      _controller.stop();
      _isControllerRepeating = false;
    } else {
      _prepareTimer?.cancel();
      _prepareTimer = null;
      _prepareSecondsLeft = 0;
      _initialPrepareSeconds = 0;
      _prepareProgress = 1.0;
    }

    // Current multiplier from tick stream
    final currentValue = tick.when(
      data: (data) => double.tryParse(data.multiplier ?? '0') ?? 0.0,
      error: (_, _) => 0.0,
      loading: () => 0.0,
    );

    // Animation triggers
    //
    // Start takeoff when we actually receive a tick value from the server,
    // instead of only relying on the round.state == 'RUNNING'. This keeps
    // the plane animation in sync with the tick stream.
    if (currentValue > 0 && !_isAnimating) {
      _startTakeoff();
    }

    // Trigger fly-away when the round crashes.
    if (round?.state == 'CRASHED' && !_hasFlownAway) {
      _startFlyAway();
    }

    // Stop the background animation in CRASHED state
    if (round?.state == 'CRASHED') {
      _controller.stop();
      _isControllerRepeating = false;
    }

    return Container(
      width: double.infinity,
      height: 294,
      decoration: const BoxDecoration(
        color: Color(0XFF271777),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -imgWidth / 2, // Move image center to bottom-left
            bottom: -imgHeight / 2,
            child: hasTickData || round?.state == 'RUNNING'
                ? AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value * 2 * pi,
                        alignment:
                            Alignment.center, // rotate around the offset center
                        child: Transform.scale(scale: 5, child: child),
                      );
                    },
                    child: SizedBox(
                      width: imgWidth,
                      height: imgHeight,
                      child: Image.asset(
                        AppImages.aviatorbg,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Transform.scale(
                    scale: 5,
                    child: SizedBox(
                      width: imgWidth,
                      height: imgHeight,
                      child: Image.asset(
                        AppImages.aviatorbg,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
          Column(
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
              if (round?.state == 'PREPARE')
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

                            // Define a baseline fly-away curve, then shift it so that
                            // the plane starts flying away from its last animated position.
                            final baselineStart = Offset(
                              width * 0.65,
                              height * 0.5,
                            );
                            final baselineControl = Offset(
                              width * 0.85,
                              height * 0.8,
                            );
                            final baselineEnd = Offset(
                              width * 1.2,
                              height + 150,
                            );

                            final start =
                                _flyAwayStartPosition ?? baselineStart;
                            final delta = start - baselineStart;
                            final control = baselineControl + delta;
                            final end = baselineEnd + delta;

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
                            final start = Offset(24, 24);
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

                          final unclampedBottomPos = y + waveOffset;
                          final bottomPos = _flyAwayController.isAnimating
                              ? unclampedBottomPos
                                    .clamp(0, double.infinity)
                                    .toDouble()
                              : unclampedBottomPos
                                    .clamp(0, height - 60)
                                    .toDouble();
                          final clampedX =
                              (_flyAwayController.isAnimating
                                      ? x
                                      : x.clamp(0, width - 70))
                                  .toDouble();
                          final currentPoint = Offset(
                            clampedX,
                            height - bottomPos,
                          );
                          _currentPlanePosition = currentPoint;

                          // Always record the plane path while the animation is active,
                          // including takeoff, waving, and fly-away segments.
                          if (_isAnimating) {
                            if (_pathPoints.isEmpty ||
                                (_pathPoints.last - currentPoint).distance >
                                    1) {
                              _pathPoints.add(currentPoint);
                            }
                          }

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              clipBehavior: Clip.hardEdge,
                              children: [
                                CustomPaint(
                                  size: Size(width, height),
                                  painter: PathPainter(
                                    round?.state == 'CRASHED'
                                        ? const <Offset>[]
                                        : _pathPoints,
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
                                if ((round?.state == 'RUNNING') ||
                                    (round == null && hasTickData))
                                  Center(
                                    child: Container(
                                      width: 390,
                                      //  height: 62,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            currentValue >= 10
                                                ? AppImages.spreadclr3
                                                : currentValue >= 2
                                                ? AppImages.spreadclr2
                                                : AppImages.spreadclr1,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${currentValue.toStringAsFixed(2)}X",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.aviatorDisplayLarge,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (round?.state == 'CRASHED' &&
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
                                          "${round?.crashAt?.toString() ?? ''}x",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.aviatorDisplayLargeSecond,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
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
    // Capture the plane's current position so the fly-away starts
    // exactly from where the plane was when the round crashed.
    _flyAwayStartPosition = _currentPlanePosition;
    // Do NOT clear _pathPoints here; the path will be cleared in PREPARE via
    // _resetAnimation(), before the next takeoff starts.
    _flyAwayController.forward(from: 0);
  }

  void _resetAnimation() {
    _isAnimating = false;
    _isWaving = false;
    _hasReachedWave = false;
    _hasFlownAway = false;
    _waveProgress = 0.0;
    _pathPoints.clear();
    _currentPlanePosition = null;
    _flyAwayStartPosition = null;

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
    // Do NOT return early when points are empty; we still want axes & dots.
    List<Offset> displayPoints = [];

    // Build displayPoints only if we actually have path points
    if (points.isNotEmpty) {
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
    }

    // Only draw fill/path/area if there are points
    if (displayPoints.isNotEmpty) {
      // ----------------------------
      // Clip region: prevent fill/path/area from drawing above the X-axis line
      // (X-axis is located at y = height - 24)
      // ----------------------------
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(0, 0, size.width, height - 24));

      // Fill gradient under curve
      final fillPaint = Paint()..style = PaintingStyle.fill;

      final fillPath = Path()
        ..moveTo(displayPoints.first.dx, displayPoints.first.dy);
      _drawSmoothCurve(fillPath, displayPoints);
      fillPath.lineTo(displayPoints.last.dx, height);
      fillPath.lineTo(displayPoints.first.dx, height);
      fillPath.close();
      final fillBounds = fillPath.getBounds();
      final fillGradient = LinearGradient(
        colors: [Colors.white, AppColors.aviatorGraphBarColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(fillBounds);
      fillPaint.shader = fillGradient;
      canvas.drawPath(fillPath, fillPaint);

      // Stroke path (curve)
      final pathPaint = Paint()
        ..strokeWidth = 6.0
        ..style = PaintingStyle.stroke
        ..color = AppColors.aviatorGraphBarColor;

      final path = Path()
        ..moveTo(displayPoints.first.dx, displayPoints.first.dy);
      _drawSmoothCurve(path, displayPoints);
      canvas.drawPath(path, pathPaint);

      // Area rectangles under the curve (xAxisPaint)
      final xAxisPaint = Paint()
        ..color = AppColors.aviatorGraphBarAreaColor2
        ..style = PaintingStyle.fill;

      for (int i = 1; i < displayPoints.length; i++) {
        final prev = displayPoints[i - 1];
        final curr = displayPoints[i];
        final rect = Rect.fromLTRB(prev.dx, curr.dy, curr.dx, height);
        canvas.drawRect(rect, xAxisPaint);
      }

      // restore so axes & dots can be drawn on top
      canvas.restore();
    }

    // From here on, we ALWAYS draw dots and axes, even when there is no path.

    // ✅ Y-axis dots (exact same alignment, just 9 total)
    final yAxisDotPaint = Paint()
      ..color = AppColors.aviatorNineteenthColor
      ..style = PaintingStyle.fill;

    const yDotCount = 9;
    final ySpacing = (height - 24 - 10) / (yDotCount - 1);
    for (int i = 0; i < yDotCount; i++) {
      final y = 10 + (ySpacing * i);
      if (y >= height - 24) continue; // skip bottom overlap
      canvas.drawCircle(Offset(10, y), 2, yAxisDotPaint);
    }

    // ✅ X-axis dots (same alignment, 9 total)
    final xAxisDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const xDotCount = 9;
    final xSpacing = (size.width - 10 - 24) / (xDotCount - 1);
    for (int i = 0; i < xDotCount; i++) {
      final x = 10 + (xSpacing * i);
      if (x <= 24) continue; // skip origin
      canvas.drawCircle(Offset(x, height - 10), 2, xAxisDotPaint);
    }

    // ✅ Axis lines (keep same position)
    final axisLinePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // X-axis line
    canvas.drawLine(
      Offset(24, height - 24),
      Offset(size.width, height - 24),
      axisLinePaint,
    );

    // Y-axis line
    canvas.drawLine(Offset(24, height - 24), Offset(24, 0), axisLinePaint);
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
  bool shouldRepaint(covariant PathPainter oldDelegate) {
    // Always repaint because the `points` list is mutated in place.
    // Relying on `==` for lists only checks identity, not contents,
    // which prevents the painter from updating when the path changes
    // between rounds or frames.
    return true;
  }
}
