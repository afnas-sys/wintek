import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/card_numbers.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/main_cards.dart';
import 'package:wintek/features/game/card_jackpot/presentation/widgets/text.dart';
import 'package:wintek/features/game/card_jackpot/providers/round_provider.dart';
import 'package:wintek/features/game/card_jackpot/providers/time_provider.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/features/game/aviator/providers/user_provider.dart';

class CardsSection extends ConsumerStatefulWidget {
  final int selectedCardTypeIndex;

  const CardsSection({super.key, required this.selectedCardTypeIndex});

  @override
  ConsumerState<CardsSection> createState() => _CardsSectionState();
}

class _CardsSectionState extends ConsumerState<CardsSection> {
  @override
  void initState() {
    super.initState();
  }

  void _showWinnerDialog(dynamic round) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          ),
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                constraints: BoxConstraints(maxWidth: 280),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.cardPrimaryColor.withOpacity(0.9),
                      AppColors.cardPrimaryColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardPrimaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 3,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top: Animated celebration icon (bomb)
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 + (animation.value * 0.2),
                          child: Lottie.asset(
                            'assets/images/bhoom.json',
                            width: 80,
                            height: 80,
                            repeat: true,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 12),
                    // Winner announcement - two lines
                    Column(
                      children: [
                        AppText(
                          text: 'You are the',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(text: '🎉', fontSize: 24),
                            SizedBox(width: 8),
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.purple,
                                  Colors.blue,
                                  Colors.pink,
                                ],
                              ).createShader(bounds),
                              child: AppText(
                                text: 'Winner',
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            AppText(text: '🎉', fontSize: 24),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Prize amount
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade600,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            text: '₹',
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(width: 4),
                          AppText(
                            text: '500.00',
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // Auto dismiss after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(cardRoundNotifierProvider, (previous, next) {
      if (next?.state == 'ENDED' && previous?.state != 'ENDED') {
        // Check if current user is a winner
        final userAsync = ref.read(userProvider);
        userAsync.maybeWhen(
          data: (userModel) {
            if (userModel != null && next!.winners != null) {
              final userId = userModel.data.id.toString();
              if (next.winners!.contains(userId)) {
                _showWinnerDialog(next);
              }
            }
          },
          orElse: () {},
        );
      }
    });

    final round = ref.watch(cardRoundNotifierProvider);
    final timer = ref.watch(timerProvider);

    // Determine overlay widget based on round state
    final overlayWidget = _getOverlayWidget(round, timer);
    final showOverlay = round == null || round.state != 'RUNNING';

    return SizedBox(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              MainCards(selectedCardTypeIndex: widget.selectedCardTypeIndex),
              const SizedBox(height: 10),
              NumbersCards(selectedCardTypeIndex: widget.selectedCardTypeIndex),
            ],
          ),
          if (showOverlay)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.cardUnfocusedColor,
                    width: 6,
                  ),
                ),
                child: Center(child: overlayWidget),
              ),
            ),
        ],
      ),
    );
  }

  Widget _getOverlayWidget(dynamic round, Duration timer) {
    if (round == null) {
      return AppText(
        text: '',
        fontSize: 50.0,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      );
    }
    switch (round.state) {
      case 'PREPARE':
        return AppText(
          text: timer.inSeconds.toString(),
          fontSize: 130.0,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        );
      case 'RUNNING':
        return AppText(
          text: timer.inSeconds.toString(),
          fontSize: 130.0,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        );
      case 'ENDED':
        return AppText(
          text: 'PREPARE',
          fontSize: 50.0,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        );
      default:
        return CircularProgressIndicator(color: Colors.white);
    }
  }
}
