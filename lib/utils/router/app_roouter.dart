import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wintek/features/auth/screens/forgot_password_screen.dart';
import 'package:wintek/features/auth/screens/login_email_screen.dart';
import 'package:wintek/features/auth/screens/login_phone_screen.dart';
import 'package:wintek/features/auth/screens/register_screen.dart';
import 'package:wintek/features/game/aviator/screen/aviator_game_screen.dart';
import 'package:wintek/utils/router/routes_names.dart';

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
      case RoutesNames.register:
        return _buildPageTransition(
          const RegisterScreen(),
          settings,
          PageTransitionType.fade,
        );
      case RoutesNames.forgot:
        return _buildPageTransition(
          const ForgotPasswordScreen(), 
          settings, 
          PageTransitionType.fade,);
        case RoutesNames.aviatorGame:
        return _buildPageTransition(
          const AviatorGameScreen(),
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
