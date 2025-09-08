import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wintek/features/auth/presentaion/screens/forgot_password_screen.dart';
import 'package:wintek/features/auth/presentaion/screens/login_email_screen.dart';
import 'package:wintek/features/auth/presentaion/screens/login_phone_screen.dart';
import 'package:wintek/features/auth/presentaion/screens/otp_varification_code_screen.dart';
import 'package:wintek/features/auth/presentaion/screens/register_email_screen.dart';
import 'package:wintek/features/auth/presentaion/screens/register_phone_screen.dart';
import 'package:wintek/features/game/aviator/screen/aviator_game_screen.dart';
import 'package:wintek/features/game/card_jackpot/presentation/screens/card_jackpot_screen.dart';

import 'package:wintek/features/home/screens/home_screen.dart';
import 'package:wintek/features/screens/splash_screen.dart';
import 'package:wintek/features/screens/welcome_screen.dart';
import 'package:wintek/features/wallet/view/wallet_screen.dart';
import 'package:wintek/utils/router/routes_names.dart';
import 'package:wintek/utils/widgets/custom_bottom_bar.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.loginWithPhone:
        return _buildPageTransition(
          const LoginPhoneScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.loginWithEmail:
        return _buildPageTransition(
          const LoginEmailScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.registerphone:
        return _buildPageTransition(
          RegisterPhoneScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.registeremail:
        return _buildPageTransition(
          const RegisterEmailScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.otp:
        return _buildPageTransition(
          const OtpVarificationCodeScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.forgot:
        return _buildPageTransition(
          const ForgotPasswordScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.aviatorGame:
        return _buildPageTransition(
          const AviatorGameScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.home:
        return _buildPageTransition(
          const HomeScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.bottombar:
        return _buildPageTransition(
          const CustomBottomBar(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.splash:
        return _buildPageTransition(
          const SplashScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.welcome:
        return _buildPageTransition(
          const WelcomeScreen(),
          settings,
          PageTransitionType.fade,
        );
      // card jackpot navigation

      case RoutesNames.cardJackpot:
        return _buildPageTransition(
          const CardJackpotScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.wallet:
        return _buildPageTransition(
          const WalletScreen(),
          settings,
          PageTransitionType.fade,
        );

      default:
        return _buildPageTransition(
          const LoginPhoneScreen(),
          settings,
          PageTransitionType.fade,
        );
    }
  }

  static PageTransition _buildPageTransition(
    Widget page,
    RouteSettings settings,
    PageTransitionType type,
  ) {
    return PageTransition(
      child: page,
      type: type,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 300),
      settings: settings,
    );
  }
}
