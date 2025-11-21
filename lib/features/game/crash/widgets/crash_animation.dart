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
      duration: const Duration(seconds: 16),
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

    ref.listen(crashGameProvider, (previous, next) {
      if (previous?.state != next.state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
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
        });
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;

        return Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: gameState.state == GameState.prepare
                ? AppColors.crashTwentyFirstColor
                : null,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, innerConstraints) {
                          final innerWidth = innerConstraints.maxWidth;
                          final innerHeight = innerConstraints.maxHeight;

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              /// -------------------------
                              /// BACKGROUND PATH DRAW
                              /// -------------------------
                              if (gameState.state == GameState.running &&
                                  _pathPoints.isNotEmpty)
                                CustomPaint(
                                  painter: CrashPathPainter(
                                    _pathPoints,
                                    gameState.currentMultiplier,
                                  ),
                                  size: Size(innerWidth, innerHeight),
                                ),

                              /// -------------------------
                              /// ROCKET ANIMATION
                              /// -------------------------
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
                                        innerWidth * 0.65,
                                        innerHeight * 0.5,
                                      );
                                      final control = Offset(
                                        innerWidth * 0.85,
                                        innerHeight * 0.8,
                                      );
                                      final end = Offset(
                                        innerWidth * 1.2,
                                        innerHeight + 150,
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
                                      final start = const Offset(0, 0);
                                      final control = Offset(
                                        innerWidth * 0.45,
                                        innerHeight * 0.1,
                                      );
                                      final end = Offset(
                                        innerWidth * 0.65,
                                        innerHeight * 0.5,
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
                                        .clamp(0, innerHeight - 60)
                                        .toDouble();

                                    final currentPoint = Offset(
                                      (x + forwardOffset).clamp(
                                        0,
                                        innerWidth - 80,
                                      ),
                                      innerHeight - bottomPos,
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
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                              /// -------------------------
                              /// MULTIPLIER TEXT
                              /// -------------------------
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

                              /// -------------------------
                              /// CRASH STATE
                              /// -------------------------
                              if (gameState.state == GameState.crashed)
                                Positioned(
                                  right: 50,
                                  top: 50,
                                  child: Row(
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
                                      ),
                                    ],
                                  ),
                                ),

                              /// -------------------------
                              /// PREPARE COUNTDOWN
                              /// -------------------------
                              if (gameState.state == GameState.prepare)
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
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
                                      Text(
                                        "${gameState.prepareSecondsLeft}",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.crashHeadlineSmall,
                                      ),
                                    ],
                                  ),
                                ),

                              /// -------------------------
                              /// PREPARE ROCKET (STATIC)
                              /// -------------------------
                              if (gameState.state == GameState.prepare)
                                Positioned(
                                  left: 0,
                                  bottom: 0,
                                  child: Lottie.asset(
                                    AppImages.crashRocket,
                                    width: 70,
                                  ),
                                ),

                              /// ---------------------------------------------------
                              ///   >>> RIGHT SIDE DOTS ANIMATION (OPTION A)
                              /// ---------------------------------------------------
                              Positioned(
                                right: 10,
                                top: 0,
                                bottom: 0,
                                width: 22,
                                child: SideDotsAnimation(
                                  isCrashed:
                                      gameState.state == GameState.crashed,
                                  multiplier: gameState.currentMultiplier,
                                  // multiplier: gameState.currentMultiplier,
                                  // isRunning:
                                  //     gameState.state == GameState.running,
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
        );
      },
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

///////////////////////////////
///  PATH LINE PAINTER
///////////////////////////////
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

///////////////////////////////
///  RIGHT SIDE DOTS ANIMATION (UPDATED)
///////////////////////////////
class SideDotsAnimation extends StatefulWidget {
  final double multiplier;
  final bool isCrashed;

  const SideDotsAnimation({
    super.key,
    required this.multiplier,
    required this.isCrashed,
  });

  @override
  State<SideDotsAnimation> createState() => _SideDotsAnimationState();
}

class _SideDotsAnimationState extends State<SideDotsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final int dotCount = 12; // total possible dots
  final double dotSize = 4; // reduced dot size

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), // slow animation
    );
  }

  @override
  void didUpdateWidget(covariant SideDotsAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Hide everything when crashed
    if (widget.isCrashed) {
      _controller.stop();
      return;
    }

    // Static dots until 3x
    if (widget.multiplier < 3) {
      _controller.stop();
      return;
    }

    // Start animation at >=3x
    if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getDotColor() {
    final m = widget.multiplier;

    if (m < 2) return Color(0XFF53987f); // static dot color
    if (m < 5) return Color(0XFF53987f);
    if (m < 10) return Colors.yellowAccent;
    if (m < 20) return Colors.orangeAccent;

    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    // Hide dots when crashed
    if (widget.isCrashed) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final spacing = height / dotCount;
        final dotColor = getDotColor();

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: List.generate(dotCount, (index) {
                // Remove 2nd, 4th, 6th... positions (even index)
                if (index % 2 == 1) return const SizedBox.shrink();

                // Static dot position (before multiplier reaches 2)
                if (widget.multiplier < 2) {
                  return Positioned(
                    right: 5,
                    top: index * spacing,
                    child: Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }

                // Animated dot position after 2x
                double pos =
                    ((_controller.value * height) + (index * spacing)) % height;

                return Positioned(
                  right: 5,
                  top: pos,
                  child: Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }
}
