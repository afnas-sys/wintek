import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/game/crash/providers/crash_game_provider.dart';

class CrashAnimation extends ConsumerStatefulWidget {
  const CrashAnimation({super.key});

  @override
  ConsumerState<CrashAnimation> createState() => _CrashAnimationState();
}

class _CrashAnimationState extends ConsumerState<CrashAnimation>
    with TickerProviderStateMixin {
  late AnimationController _takeoffController;
  late AnimationController _waveController;
  late AnimationController _flyAwayController;

  late Animation<double> _takeoffAnimation;
  late Animation<double> _flyAwayAnimation;

  bool _isWaving = false;
  bool _isAnimating = false;
  bool _hasReachedWave = false;

  final List<Offset> _pathPoints = [];

  double _waveProgress = 0.0;
  double _forwardProgress = 0.0;
  final double _waveAmplitude = 15.0;
  final double _waveFrequency = 0.05;

  final double _planeWidth = 70;

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
      duration: const Duration(seconds: 2),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(crashGameProvider);

    // Listen to state changes to trigger animations
    ref.listen(crashGameProvider, (previous, next) {
      if (previous?.state != next.state) {
        switch (next.state) {
          case GameState.running:
            _startRunningAnimation();
            break;
          case GameState.crashed:
            _startCrashAnimation();
            break;
          case GameState.prepare:
            _resetAnimation();
            break;
        }
      }
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 294,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.aviatorFifteenthColor,
              width: 1,
            ),
            color: gameState.state == GameState.prepare
                ? AppColors.crashSecondaryColor
                : null,
          ),
          child: Stack(
            children: [
              if (gameState.state == GameState.running ||
                  gameState.state == GameState.crashed)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Lottie.asset(
                        AppImages.crashBg,
                        width: _planeWidth,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Top bar

                    // Game area
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final height = constraints.maxHeight;

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Remove path painter - only show plane flying

                              // Path drawing
                              if (gameState.state == GameState.running &&
                                  _pathPoints.isNotEmpty)
                                CustomPaint(
                                  painter: CrashPathPainter(
                                    _pathPoints,
                                    gameState.currentMultiplier,
                                  ),
                                  size: Size(width, height),
                                ),

                              // Plane animation
                              if (gameState.state == GameState.running)
                                AnimatedBuilder(
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
                                      final start = Offset(
                                        width * 0.65,
                                        height * 0.5,
                                      );
                                      final control = Offset(
                                        width * 0.85,
                                        height * 0.8,
                                      );
                                      final end = Offset(
                                        width * 1.2,
                                        height + 150,
                                      );
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
                                      final control = Offset(
                                        width * 0.45,
                                        height * 0.1,
                                      );
                                      final end = Offset(
                                        width * 0.65,
                                        height * 0.5,
                                      );

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
                                    double forwardOffset = 0.0;
                                    if (_isWaving &&
                                        !_flyAwayController.isAnimating) {
                                      waveOffset =
                                          sin(_waveProgress * _waveFrequency) *
                                          _waveAmplitude;
                                      forwardOffset = _forwardProgress * 20;
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
                                      (x + forwardOffset).clamp(0, width - 80),
                                      height - bottomPos,
                                    );

                                    if (_isAnimating &&
                                        !_flyAwayController.isAnimating &&
                                        !_isWaving) {
                                      if (_pathPoints.isEmpty ||
                                          (_pathPoints.last - currentPoint)
                                                  .distance >
                                              1) {
                                        _pathPoints.add(currentPoint);
                                      }
                                    }

                                    return Positioned(
                                      left: currentPoint.dx,
                                      bottom: bottomPos,
                                      child: Transform.rotate(
                                        angle: planeAngle,
                                        child: Lottie.asset(
                                          AppImages.crashRocket,
                                          width: _planeWidth,
                                          //  height: _planeHeight,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                              // Multiplier display
                              if (gameState.state == GameState.running)
                                Center(
                                  child: Text(
                                    "${gameState.currentMultiplier.toStringAsFixed(2)}x",
                                    style: const TextStyle(
                                      color: AppColors.crashPrimaryColor,
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                              // Crash explosion at right side
                              if (gameState.state == GameState.crashed)
                                Positioned(
                                  right: 50,
                                  top: 50,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${gameState.crashMultiplier.toStringAsFixed(2)}x",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.crashHeadlineSmall,
                                      ),
                                      const SizedBox(width: 16),
                                      Lottie.asset(
                                        AppImages.crashExplosion,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                ),

                              // Prepare countdown
                              if (gameState.state == GameState.prepare)
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Circular progress indicator
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: CircularProgressIndicator(
                                          value:
                                              gameState.prepareSecondsLeft / 10,
                                          strokeWidth: 8,
                                          backgroundColor:
                                              AppColors.crashThirdColor,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(AppColors.crashFourthColor),
                                        ),
                                      ),
                                      // Countdown text in center
                                      Text(
                                        "${gameState.prepareSecondsLeft}",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.crashHeadlineSmall,
                                      ),
                                    ],
                                  ),
                                ),

                              // Initial plane position
                              if (gameState.state == GameState.prepare)
                                Positioned(
                                  left: 0,
                                  bottom: 0,
                                  child: Lottie.asset(
                                    AppImages.crashRocket,
                                    width: 70,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _startRunningAnimation() {
    setState(() {
      _isAnimating = true;
      _hasReachedWave = false;
      _isWaving = false;
      _waveProgress = 0.0;
      _forwardProgress = 0.0;
      _pathPoints.clear();
    });
    _takeoffController.forward(from: 0);
  }

  void _startCrashAnimation() {
    setState(() {
      _isWaving = false;
    });
    _waveController.stop();
    _pathPoints.clear();
    _flyAwayController.forward(from: 0);
  }

  void _resetAnimation() {
    setState(() {
      _isWaving = false;
      _isAnimating = false;
      _hasReachedWave = false;
      _waveProgress = 0.0;
      _forwardProgress = 0.0;
      _pathPoints.clear();
    });
    _takeoffController.reset();
    _waveController.stop();
    _flyAwayController.reset();
  }
}

class CrashPathPainter extends CustomPainter {
  final List<Offset> pathPoints;
  final double multiplier;

  CrashPathPainter(this.pathPoints, this.multiplier);

  @override
  void paint(Canvas canvas, Size size) {
    if (pathPoints.length < 2) return;

    final path = Path();
    path.moveTo(pathPoints.first.dx, pathPoints.first.dy);
    for (int i = 1; i < pathPoints.length; i++) {
      path.lineTo(pathPoints[i].dx, pathPoints[i].dy);
    }

    Color color;
    if (multiplier < 2) {
      color = Colors.blue;
    } else if (multiplier < 10) {
      color = Colors.green;
    } else {
      color = Colors.orange;
    }

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final rect = path.getBounds();
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.transparent, color],
    ).createShader(rect);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
