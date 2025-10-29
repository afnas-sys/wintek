import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wintek/features/auth/presentaion/screens/forgot_password_screen.dart';
import 'package:wintek/features/auth/presentaion/screens/login_screen.dart';
import 'package:wintek/features/auth/presentaion/screens/otp_varification_screen.dart';
import 'package:wintek/features/auth/presentaion/screens/register_screen.dart';
import 'package:wintek/features/game/aviator/screen/aviator_game_screen.dart';
import 'package:wintek/features/game/card_jackpot/presentation/screens/card_jackpot_screen.dart';
import 'package:wintek/features/game/carrom/screens/carrom_game_screen.dart';
import 'package:wintek/features/game/crash/screens/crash_game_screen.dart';
import 'package:wintek/features/game/spin_to_win/screens/spin_to_win_screen.dart';

import 'package:wintek/features/home/screens/home_screen.dart';
import 'package:wintek/features/payment/deposit/screens/deposit_screen.dart';
import 'package:wintek/features/payment/withdraw/screens/withdraw_screen.dart';
import 'package:wintek/features/screens/splash_screen.dart';
import 'package:wintek/features/screens/welcome_screen.dart';
import 'package:wintek/features/wallet/view/wallet_screen.dart';
import 'package:wintek/core/router/routes_names.dart';
import 'package:wintek/core/widgets/custom_bottom_bar.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.loginScreen:
        return _buildPageTransition(
          const LoginScreen(),
          settings,
          PageTransitionType.fade,
        );
      // case RoutesNames.loginWithEmail:
      //   return _buildPageTransition(
      //     const LoginEmailScreen(),
      //     settings,
      //     PageTransitionType.fade,
      //   );
      case RoutesNames.registerScreen:
        return _buildPageTransition(
          RegisterScreen(),
          settings,
          PageTransitionType.fade,
        );
      // case RoutesNames.registeremail:
      //   return _buildPageTransition(
      //     const RegisterEmailScreen(),
      //     settings,
      //     PageTransitionType.fade,
      //   );
      case RoutesNames.otp:
        return _buildPageTransition(
          const OtpVarificationScreen(),
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
      case RoutesNames.carrom:
        return _buildPageTransition(
          const CarromGameScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.crash:
        return _buildPageTransition(
          const CrashGameScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.spinToWin:
        return _buildPageTransition(
          const SpinToWinScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.withdraw:
        return _buildPageTransition(
          const WithdrawScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.deposit:
        return _buildPageTransition(
          const DepositScreen(),
          settings,
          PageTransitionType.fade,
        );

      default:
        return _buildPageTransition(
          const LoginScreen(),
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
