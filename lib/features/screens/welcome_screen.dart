import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wintek/utils/router/routes_names.dart';
import 'package:wintek/utils/widgets/custom_elevated_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _screens = [
    {
      'image': 'assets/images/welcome_sc1.png',
      'title': 'Play Exciting Games',
      'description': 'Aviator, Crash, Carrom, Spin-to-Win & more in one app.',
    },
    {
      'image': 'assets/images/welcome_sc2.png',
      'title': 'Win  Instantly',
      'description': 'Play and win real money every minute.',
    },
    {
      'image': 'assets/images/welcome_sc3.png',
      'title': 'Withdraw Anytime',
      'description': 'Cash out instantly to your bank or UPI.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/welcome_bg.png"),
            fit: BoxFit.fill,
          ),
          gradient: RadialGradient(
            colors: [
              Color(0xFF140A2D),
              Color(0xFF6041FF).withOpacity(0),
              Color(0x006041FF),
            ],
            radius: 150,
          ),
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _screens.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image
                      Image.asset(
                        _screens[index]['image']!,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 80),

                      // Page Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _screens.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 12 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 70),
                      // Title Text
                      Text(
                        _screens[index]['title']!,
                        style: GoogleFonts.roboto(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Description Text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _screens[index]['description']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color(0XFFB0B3B8),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle skip action (e.g., navigate to main screen)
                      Navigator.pushReplacementNamed(
                        context,
                        RoutesNames.bottombar,
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0XFF6041FF),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  _currentPage == _screens.length - 1
                      ? CustomElevatedButton(
                          backgroundColor: Color(0XFFFFA82E),
                          height: 52,
                          width: 147,
                          borderRadius: 30,
                          onPressed: () async {
                            final storage = const FlutterSecureStorage();
                            await storage.write(
                              key: 'isFirstLaunch',
                              value: 'false',
                            );
                            Navigator.pushReplacementNamed(
                              context,
                              RoutesNames.loginScreen,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Get Started',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0XFF0B0F1A),
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                FontAwesomeIcons.angleRight,
                                size: 20,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _currentPage == 0
                                  ? Color(0XFF412C73)
                                  : Color(0xFFFFA82E).withOpacity(20 / 100),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (_currentPage < _screens.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              }
                            },
                            icon: Icon(
                              FontAwesomeIcons.angleRight,
                              color: _currentPage == 0
                                  ? Colors.white
                                  : Color(0xFFFFA82E),
                            ),
                            iconSize: 20,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
