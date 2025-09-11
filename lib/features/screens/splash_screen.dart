// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wintek/features/auth/domain/constants/secure_storage_constants.dart';
import 'package:wintek/utils/router/routes_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = const FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await _storage.read(key: SecureStorageConstants.tokenKey);
    final isFirstLaunch = await _storage.read(key: 'isFirstLaunch');

    if (token != null) {
      //already logged in
      Navigator.pushReplacementNamed(context, RoutesNames.bottombar);
    } else {
      if (isFirstLaunch == null || isFirstLaunch == 'true') {
        Navigator.pushReplacementNamed(context, RoutesNames.welcome);
      } else {
        Navigator.pushReplacementNamed(context, RoutesNames.loginScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: ,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF211250),
              Color(0xFF6041FF).withOpacity(0),
              Color(0x006041FF),
            ],
            radius: 150,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Image.asset("assets/images/splash.png", height: 62, width: 226),
            ],
          ),
        ),
      ),
    );
  }
}
