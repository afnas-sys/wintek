import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140A2D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 16, // 20px on 428px screen
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Bonus Section
              _buildWelcomeBonusSection(),

              SizedBox(height: 20),

              // Play More, Earn More Section
              _buildSectionTitle('Play More, Earn More'),

              SizedBox(height: 12),

              _buildGameCarousel(),

              SizedBox(height: 20),

              _buildSectionTitle('Milestone Rewards'),

              SizedBox(height: 12),

              // Invite Friends Section
              _buildInviteFriends(),

              SizedBox(height: 20),

              _buildSectionTitle('Milestone Rewards'),

              SizedBox(height: 12),

              // Games played
              _buildGamesplayed(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBonusSection() {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      height: 186,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.welcomeBonus),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            AppImages.welcomeBonusText,

            //   fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.aviatorBodyTitleMdeium,
    );
  }

  Widget _buildGameCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        height: 184.0,
        //  enlargeCenterPage: true, // enlarge the current page
        viewportFraction:
            0.86, // adjusted for approximately 368 width on 428px screen
        onPageChanged: (index, reason) {
          setState(() {}); // if you need to update indicators
        },
      ),
      items:
          [
            AppImages.offerCarousel1,
            AppImages.offerCarousel2,
            // Add more images here
          ].map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // optional rounded corners
                    child: Image.asset(imagePath, fit: BoxFit.fill),
                  ),
                );
              },
            );
          }).toList(),
    );
  }

  //invite friends
  Widget _buildInviteFriends() {
    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(AppImages.inviteFriends)),
      ),
    );
  }

  //games played
  Widget _buildGamesplayed() {
    return Container(
      width: double.infinity,
      height: 152,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(AppImages.gamesPlayed)),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
