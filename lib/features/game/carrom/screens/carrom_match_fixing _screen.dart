import 'dart:async';
import 'package:flutter/material.dart';

import 'package:wintek/core/constants/app_images.dart';
import 'carrom_gameplay_screen.dart';

class CarromMatchFixingScreen extends StatefulWidget {
  const CarromMatchFixingScreen({super.key});

  @override
  State<CarromMatchFixingScreen> createState() =>
      _CarromMatchFixingScreenState();
}

class _CarromMatchFixingScreenState extends State<CarromMatchFixingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CarromGameplayScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   backgroundColor: const Color(0xFF3B00CE),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 164, vertical: 184),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.carromMatchBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: 1,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(
                    'assets/images/carromUser.png',
                    fit: BoxFit.fill,
                  ),
                ),
                const Text(
                  'John V',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            Column(
              spacing: 1,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(
                    'assets/images/carromUser.png',
                    fit: BoxFit.fill,
                  ),
                ),

                const Text(
                  'George',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
