import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _screens = [
    {
      'image': 'assets/images/plane.png',
      'title': 'Welcome to Our App',
      'description': 'Discover amazing features and get started with ease.',
    },
    {
      'image': 'assets/images/spin.png',
      'title': 'Explore New Possibilities',
      'description': 'Unlock a world of opportunities with our platform.',
    },
    {
      'image': 'assets/images/rocket.png',
      'title': 'Get Started Today',
      'description': 'Join our community and start your journey now.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.amber),
      child: Scaffold(
        body: SafeArea(
          child: Column(
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
                        const SizedBox(height: 20),
                        // Title Text
                        Text(
                          _screens[index]['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Description Text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            _screens[index]['description']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
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
                      color: _currentPage == index ? Colors.white : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Handle skip action (e.g., navigate to main screen)
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_currentPage < _screens.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          // Handle next action on last screen (e.g., navigate to main screen)
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
