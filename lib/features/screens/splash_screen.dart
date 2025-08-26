import 'package:flutter/material.dart';
import 'package:wintek/utils/router/app_roouter.dart';
import 'package:wintek/utils/router/routes_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, RoutesNames.welcome);
    });
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
            // focal: Alignment.center,
            // tileMode: TileMode.clamp,

            //  stops: [0.0, 1], // 0% to 100%
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
