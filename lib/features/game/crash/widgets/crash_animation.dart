import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/utils/sound_manager.dart';
import 'package:wintek/features/game/crash/providers/crash_music_provider.dart';
import 'package:wintek/features/game/crash/providers/crash_round_provider.dart';
import 'package:wintek/features/game/crash/widgets/crash_settings_drawer.dart';

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
  late AnimationController _textController;

  late Animation<double> _takeoffAnimation;
  late Animation<double> _flyAwayAnimation;
  late Animation<Offset> _textAnimation;

  bool _isWaving = false;
  bool _isAnimating = false;
  bool _hasReachedWave = false;

  final List<Offset> _pathPoints = [];

  final double _planeWidth = 70;

  double _innerWidth = 0.0;
  double _innerHeight = 0.0;
  Offset? _crashPosition;

  final double _rocketLeftOffset = -20.0;
  final double _rocketBottomOffset = -5.0;

  String _currentLabel = '';
  String _previousLabel = '';
  bool _isFirstRunning = false;
  bool _hasPlayedStartSound =
      false; // Track if start sound has been played for current round

  // 👈 PREPARE state countdown variables
  double _prepareSecondsLeft = 0.0;
  int _initialPrepareSeconds = 0;
  Timer? _prepareTimer;

  final Map<String, List<Color>> _labelColors = {
    'NOT BAD': [Color(0XFF11FED7), Color(0XFFF7FEFD)],
    'NICE': [Color(0XFF0050F2), Color(0XFF00F4E0)],
    'AWESOME': [Color(0XFFF45FFF), Color(0XFF4447FF)],
    'WICKED': [Color(0XFFCD015E), Color(0XFF9600FF)],
    'GODLIKE': [Color(0XFFEB8256), Color(0XFFE73C5D)],
    'LEGENDARY': [Color(0XFFF4F564), Color(0XFFFA7F00)],
    'CRASH': [AppColors.crashPrimaryColor, AppColors.crashPrimaryColor],
  };

  @override
  void initState() {
    super.initState();

    _takeoffController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _takeoffAnimation = CurvedAnimation(
      parent: _takeoffController,
      curve: Curves.easeInOutCubic,
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );

    _waveController.addListener(() {
      if (_isWaving) {
        setState(() {});
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

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _textAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Auto-play music if switch is ON
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isMusicOn = ref.read(crashMusicProvider);
      if (isMusicOn) {
        SoundManager.aviatorMusic();
      }
    });
  }

  @override
  void dispose() {
    _takeoffController.dispose();
    _waveController.dispose();
    _flyAwayController.dispose();
    _textController.dispose();
    _prepareTimer?.cancel();

    // Stop background music when widget is disposed
    SoundManager.stopAviatorMusic();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final round = ref.watch(crashRoundNotifierProvider);
    final tick = ref.watch(crashTickProvider);

    // Determine if we already have any tick data
    final hasTickData = tick.maybeWhen(data: (_) => true, orElse: () => false);

    ref.listen(crashRoundNotifierProvider, (previous, next) {
      if (previous?.state != next?.state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          switch (next?.state) {
            case 'RUNNING':
              // Animation will be triggered by tick event
              break;
            case 'CRASHED':
              _startCrashAnimation();
              break;
            case 'PREPARE':
              _resetAnimation();
              break;
          }
        });
      }
    });

    ref.listen(crashTickProvider, (previous, next) {
      final multiplier = next.maybeWhen(
        data: (data) => double.tryParse(data.multiplier ?? '0') ?? 0.0,
        orElse: () => 0.0,
      );

      if (!_isAnimating) {
        if (multiplier > 0) {
          _startRunningAnimation();
        }
      }

      // Play start sound only at the very beginning (when multiplier is between 1.00 and 1.20)
      final roundState = ref.read(crashRoundNotifierProvider)?.state;
      if (multiplier >= 1.00 &&
          multiplier <= 1.20 &&
          !_hasPlayedStartSound &&
          roundState == 'RUNNING') {
        final isStartSoundOn = ref.read(crashStartSoundProvider);
        if (isStartSoundOn) {
          SoundManager.crashStartSound();
        }
        _hasPlayedStartSound = true;
      }
    });

    // PREPARE countdown logic
    if (round?.state == 'PREPARE') {
      final msRemaining = int.tryParse(round?.msRemaining ?? '0') ?? 0;
      final secondsRemaining = (msRemaining / 1000).ceil();
      if (_initialPrepareSeconds != secondsRemaining && secondsRemaining > 0) {
        _initialPrepareSeconds = secondsRemaining;
        _prepareSecondsLeft = secondsRemaining.toDouble();
        if (_prepareTimer == null) _startPrepareCountdown();
      }

      // When we enter PREPARE after a CRASHED round,
      // ensure all animation state is reset exactly once here,
      // instead of from the fly-away controller callback. This
      // avoids wiping the new round's path if a new takeoff starts
      // before the previous fly-away animation completes.
      if (_isAnimating ||
          _hasReachedWave ||
          _takeoffController.isAnimating ||
          _flyAwayController.isAnimating ||
          _waveController.isAnimating) {
        _resetAnimation();
      }
    } else {
      _prepareTimer?.cancel();
      _prepareTimer = null;
      _prepareSecondsLeft = 0;
      _initialPrepareSeconds = 0;
    }

    // Current multiplier from tick stream
    final currentValue = tick.when(
      data: (data) => double.tryParse(data.multiplier ?? '0') ?? 0.0,
      error: (_, _) => 0.0,
      loading: () => 0.0,
    );

    // Animation triggers
    if (currentValue > 0 && !_isAnimating) {
      _startRunningAnimation();
    }

    // Trigger crash when the round crashes.
    if (round?.state == 'CRASHED') {
      _startCrashAnimation();
    }

    // Calculate multiplier label
    String newLabel = '';
    if (round?.state == 'RUNNING') {
      double m = currentValue;
      if (m > 30) {
        newLabel = 'LEGENDARY';
      } else {
        switch (m) {
          case >= 10:
            newLabel = 'GODLIKE';
          case >= 7:
            newLabel = 'WICKED';
          case >= 5:
            newLabel = 'AWESOME';
          case >= 3:
            newLabel = 'NICE';
          case > 2:
            newLabel = 'NOT BAD';
        }
      }
    } else if (round?.state == 'CRASHED') {
      newLabel = 'CRASH';
    }

    if (newLabel != _previousLabel) {
      _previousLabel = newLabel;
      if (!_isFirstRunning) {
        _currentLabel = newLabel;
        _textController.forward(from: 0);
      }
      _isFirstRunning = false;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;

        return Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // color: Colors.red,
            color: round?.state == 'PREPARE'
                ? AppColors.crashTwentyFirstColor
                : null,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              final RenderBox renderBox =
                                  context.findRenderObject() as RenderBox;
                              final position = renderBox.localToGlobal(
                                Offset.zero,
                              );
                              final size = renderBox.size;
                              showCrashSettingsDrawer(
                                context: context,
                                position: position,
                                size: size,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    // Container(height: 100, width: 100, color: Colors.amber),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, innerConstraints) {
                          final innerWidth = innerConstraints.maxWidth;
                          final innerHeight = innerConstraints.maxHeight;

                          if (_innerWidth != innerWidth ||
                              _innerHeight != innerHeight) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  _innerWidth = innerWidth;
                                  _innerHeight = innerHeight;
                                });
                              }
                            });
                          }

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              /// -------------------------
                              /// BACKGROUND PATH DRAW
                              /// -------------------------
                              if ((round?.state == 'RUNNING' ||
                                      (round == null && hasTickData)) &&
                                  _pathPoints.isNotEmpty)
                                CustomPaint(
                                  painter: CrashPathPainter(
                                    _pathPoints,
                                    currentValue,
                                  ),
                                  size: Size(innerWidth, innerHeight),
                                ),

                              /// -------------------------
                              /// ROCKET ANIMATION
                              /// -------------------------
                              if (round?.state == 'RUNNING' ||
                                  (round == null && hasTickData))
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
                                        innerWidth * 0.7,
                                        innerHeight * 0.7,
                                      );

                                      x =
                                          (1 - t) * (1 - t) * start.dx +
                                          2 * (1 - t) * t * control.dx +
                                          t * t * end.dx;

                                      y =
                                          (1 - t) * (1 - t) * start.dy +
                                          2 * (1 - t) * t * control.dy +
                                          t * t * end.dy;
                                    }

                                    final bottomPos = y
                                        .clamp(0, innerHeight - 60)
                                        .toDouble();

                                    final currentPoint = Offset(
                                      x.clamp(0, innerWidth - 80),
                                      innerHeight - bottomPos,
                                    );

                                    if (_isAnimating &&
                                        !_flyAwayController.isAnimating) {
                                      if (_pathPoints.isEmpty ||
                                          (_pathPoints.last - currentPoint)
                                                  .distance >
                                              0.5) {
                                        _pathPoints.add(currentPoint);
                                      }
                                    }

                                    return Positioned(
                                      left: currentPoint.dx + _rocketLeftOffset,
                                      bottom: bottomPos + _rocketBottomOffset,
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
                              if (round?.state == 'RUNNING' ||
                                  (round == null && hasTickData))
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: currentValue.toStringAsFixed(2),
                                          style: const TextStyle(
                                            color: AppColors.crashPrimaryColor,
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "x",
                                              style: TextStyle(
                                                fontSize: 48,
                                                foreground: Paint()
                                                  ..shader =
                                                      const LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          Color(0XFF0C7D9A),
                                                          Color(0XFF0AD69F),
                                                        ],
                                                      ).createShader(
                                                        Rect.fromLTWH(
                                                          0,
                                                          0,
                                                          200,
                                                          40,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (_currentLabel.isNotEmpty)
                                        Positioned(
                                          top: -40,
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: SlideTransition(
                                              position: _textAnimation,
                                              child: ShaderMask(
                                                shaderCallback: (Rect bounds) {
                                                  return LinearGradient(
                                                    colors:
                                                        _labelColors[_currentLabel] ??
                                                        [
                                                          AppColors
                                                              .crashPrimaryColor,
                                                          AppColors
                                                              .crashPrimaryColor,
                                                        ],
                                                  ).createShader(bounds);
                                                },
                                                child: Text(
                                                  _currentLabel,
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors
                                                        .crashPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                              /// -------------------------
                              /// CRASH STATE
                              /// -------------------------
                              if (round?.state == 'CRASHED')
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Text(
                                        "${double.tryParse(round?.crashAt ?? '0')?.toStringAsFixed(2) ?? '0.00'}x",
                                        style: Theme.of(context)
                                            .textTheme
                                            .crashHeadlineSmall
                                            .copyWith(fontSize: 48),
                                      ),
                                      if (_currentLabel.isNotEmpty)
                                        Positioned(
                                          top: -40,
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: SlideTransition(
                                              position: _textAnimation,
                                              child: ShaderMask(
                                                shaderCallback: (Rect bounds) {
                                                  return LinearGradient(
                                                    colors:
                                                        _labelColors[_currentLabel] ??
                                                        [
                                                          AppColors
                                                              .crashPrimaryColor,
                                                          AppColors
                                                              .crashPrimaryColor,
                                                        ],
                                                  ).createShader(bounds);
                                                },
                                                child: Text(
                                                  _currentLabel,
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors
                                                        .crashPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              if (round?.state == 'CRASHED' &&
                                  _crashPosition != null)
                                Positioned(
                                  left:
                                      _crashPosition!.dx -
                                      40 +
                                      _rocketLeftOffset,
                                  bottom:
                                      (_innerHeight - _crashPosition!.dy) -
                                      40 +
                                      _rocketBottomOffset,
                                  child: Lottie.asset(
                                    AppImages.crashExplosion,
                                    width: 150,
                                    height: 150,
                                  ),
                                ),

                              /// -------------------------
                              /// PREPARE COUNTDOWN
                              /// -------------------------
                              if (round?.state == 'PREPARE')
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: CircularProgressIndicator(
                                          value: _prepareSecondsLeft / 10.0,
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
                                        "${_prepareSecondsLeft.floor()}",
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
                              if (round?.state == 'PREPARE')
                                Positioned(
                                  left: 0 + _rocketLeftOffset,
                                  bottom: 0 + _rocketBottomOffset,
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
                                  isCrashed: round?.state == 'CRASHED',
                                  isRunning: round?.state == 'RUNNING',
                                  isPrepare: round?.state == 'PREPARE',
                                  multiplier: currentValue,
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
      _pathPoints.clear();
      _currentLabel = '';
      _previousLabel = '';
      _isFirstRunning = true;
    });

    _takeoffController.forward(from: 0);
  }

  void _startCrashAnimation() {
    setState(() {
      _isWaving = false;
    });
    _waveController.stop();
    _pathPoints.clear();

    // Play flew away sound if enabled
    final isStartSoundOn = ref.read(crashStartSoundProvider);
    if (isStartSoundOn) {
      SoundManager.aviatorFlewAwaySound();
    }

    // Calculate rocket position at crash time
    final t = _takeoffAnimation.value;
    final start = const Offset(0, 0);
    final control = Offset(_innerWidth * 0.45, _innerHeight * 0.1);
    final end = Offset(_innerWidth * 0.7, _innerHeight * 0.7);

    double x =
        (1 - t) * (1 - t) * start.dx +
        2 * (1 - t) * t * control.dx +
        t * t * end.dx;
    double y =
        (1 - t) * (1 - t) * start.dy +
        2 * (1 - t) * t * control.dy +
        t * t * end.dy;

    double bottomPos = y.clamp(0, _innerHeight - 60);
    _crashPosition = Offset(
      x.clamp(0, _innerWidth - 80),
      _innerHeight - bottomPos,
    );

    _flyAwayController.forward(from: 0);
  }

  // PREPARE countdown
  void _startPrepareCountdown() {
    _prepareTimer?.cancel();

    _prepareTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_prepareSecondsLeft <= 0.1) {
        timer.cancel();
        _prepareTimer = null;
        setState(() {
          _prepareSecondsLeft = 0.0;
        });
      } else {
        setState(() {
          _prepareSecondsLeft -= 0.1;
        });
      }
    });
  }

  void _resetAnimation() {
    setState(() {
      _isWaving = false;
      _isAnimating = false;
      _hasReachedWave = false;
      _pathPoints.clear();
      _crashPosition = null;
      _currentLabel = '';
      _previousLabel = '';
      _isFirstRunning = false;
      _hasPlayedStartSound = false; // Reset for next round
    });

    _takeoffController.reset();
    _waveController.stop();
    _flyAwayController.reset();
    _textController.reset();
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
  final bool isRunning;
  final bool isPrepare;

  const SideDotsAnimation({
    super.key,
    required this.multiplier,
    required this.isCrashed,
    required this.isRunning,
    required this.isPrepare,
  });

  @override
  State<SideDotsAnimation> createState() => _SideDotsAnimationState();
}

class _SideDotsAnimationState extends State<SideDotsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final int dotCount = 12; // total possible dots
  final double dotSize = 4; // reduced dot size
  bool _hasStartedAnimation = false; // Track if animation has started
  double _cachedSpacing = 0.0; // Cache spacing to prevent recalculation
  double _cachedHeight = 0.0; // Cache height
  bool _waitForValidStart = false; // Flag to wait for a valid start multiplier

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

    // Reset animation flag when not running or crashed
    if (!widget.isRunning || widget.isCrashed) {
      _controller.stop();
      _controller.reset();
      _hasStartedAnimation = false;
      _waitForValidStart = false;
      return;
    }

    // Detect transition from PREPARE to RUNNING
    // If we just switched to running, we must wait for a low multiplier
    // to ensure we aren't seeing a stale high multiplier from previous round.
    if (oldWidget.isPrepare && widget.isRunning) {
      _waitForValidStart = true;
    }

    // If we are waiting for a valid start, check if we have hit a low multiplier
    if (_waitForValidStart) {
      if (widget.multiplier <= 1.2) {
        _waitForValidStart = false;
      }
    }

    // Static dots until 1.5x or if waiting for valid start
    if (widget.multiplier < 1.5 || _waitForValidStart) {
      _controller.stop();
      _controller.reset();
      _hasStartedAnimation = false;
      return;
    }

    // Start animation at >=1.5x
    if (!_hasStartedAnimation && widget.multiplier >= 1.5) {
      _hasStartedAnimation = true;
      _controller.forward(from: 0);
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getDotColor() {
    // Always show green during PREPARE state or early RUNNING state
    if (widget.isPrepare || !widget.isRunning) return Color(0XFF53987f);

    final m = widget.multiplier;

    // Keep green until multiplier is stable and >= 5
    if (m < 5) return Color(0XFF53987f);
    if (m < 10) return Colors.yellowAccent;
    if (m < 20) return Colors.orangeAccent;

    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    // Hide dots only when crashed
    if (widget.isCrashed) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;

        // Only update cached values when height actually changes
        if (_cachedHeight != height) {
          _cachedHeight = height;
          _cachedSpacing = height / dotCount;
        }

        final spacing = _cachedSpacing;
        final dotColor = getDotColor();

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: List.generate(dotCount, (index) {
                // Remove 2nd, 4th, 6th... positions (even index)
                if (index % 2 == 1) return const SizedBox.shrink();

                // Calculate position
                double topPosition;
                if (widget.isPrepare ||
                    widget.multiplier < 1.5 ||
                    _waitForValidStart) {
                  // Static position - keep dots still until animation starts
                  topPosition = index * spacing;
                } else {
                  // Animated position after animation has started
                  topPosition =
                      ((_controller.value * _cachedHeight) +
                          (index * spacing)) %
                      _cachedHeight;
                }

                return Positioned(
                  key: ValueKey('dot_$index'),
                  right: 5,
                  top: topPosition,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
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
