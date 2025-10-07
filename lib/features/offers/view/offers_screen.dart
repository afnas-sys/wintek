import 'package:flutter/material.dart';
import 'dart:math' as math;

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final PageController _pageController = PageController();
  double _getResponsiveFontSize(double factor, double screenWidth) {
    double base = screenWidth * factor;
    if (screenWidth < 360) return math.max(base * 0.8, 12.0);
    if (screenWidth > 600) return math.min(base * 1.2, 60.0);
    return base;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF140A2D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.047, // 20px on 428px screen
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Bonus Section
              _buildWelcomeBonusSection(screenWidth, screenHeight),

              SizedBox(height: screenHeight * 0.02),

              // Play More, Earn More Section
              _buildSectionTitle('Play More, Earn More', screenWidth),

              SizedBox(height: screenHeight * 0.015),

              // Carousel Section
              _buildGameCarousel(screenWidth, screenHeight),

              SizedBox(height: screenHeight * 0.03),

              // Invite Friends Section
              _buildInviteFriendsSection(screenWidth, screenHeight),

              SizedBox(height: screenHeight * 0.03),

              // Milestone Rewards Section
              _buildSectionTitle('Milestone Rewards', screenWidth),

              SizedBox(height: screenHeight * 0.015),

              _buildMilestoneRewardsSection(screenWidth, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBonusSection(double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.18,
      padding: EdgeInsets.all(screenWidth * 0.047),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage(
            'https://api.builder.io/api/v1/image/assets/TEMP/1c5cb8784b73568cbd52bb5fdb864afa85dba5c1?width=776',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: screenWidth > 600
          ? Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'WELCOME BONUS',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Bayon',
                            fontSize: _getResponsiveFontSize(
                              0.08,
                              screenWidth,
                            ), // Reduced size
                            fontWeight: FontWeight.w400,
                            height: 1.14,
                            foreground: Paint()
                              ..shader =
                                  const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF01AEFB),
                                      Color(0xFF017FFA),
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 70),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: Text(
                          'Get 100% Extra on First Deposit!',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: _getResponsiveFontSize(0.03, screenWidth),
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.01,
                  ),
                  child: Text(
                    'Deposit Now',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: _getResponsiveFontSize(0.025, screenWidth),
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'WELCOME BONUS',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Bayon',
                    fontSize: _getResponsiveFontSize(
                      0.08,
                      screenWidth,
                    ), // Reduced size
                    fontWeight: FontWeight.w400,
                    height: 1.14,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF01AEFB), Color(0xFF017FFA)],
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Get 100% Extra on First Deposit!',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: _getResponsiveFontSize(0.03, screenWidth),
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.01,
                  ),
                  child: Text(
                    'Deposit Now',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: _getResponsiveFontSize(0.025, screenWidth),
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title, double screenWidth) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: _getResponsiveFontSize(0.042, screenWidth),
        fontWeight: FontWeight.w500,
        color: Colors.white,
        height: 1.33,
      ),
    );
  }

  Widget _buildGameCarousel(double screenWidth, double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.23,
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {});
        },
        children: [
          _buildGameCard(
            screenWidth,
            screenHeight,
            'Play 10 Aviator rounds today & get ₹100 cashback.',
            '6/10',
            'https://api.builder.io/api/v1/image/assets/TEMP/1fc76d1f685353f967610248c5bb1c0d35bb6d7f?width=84',
            const [Color(0xFF240100)],
            const [Color(0x4DFD0700), Color(0x00FD0700)],
            const [Color(0x33FD0700), Color(0x00FD0700)],
          ),
          _buildGameCard(
            screenWidth,
            screenHeight,
            'Play 10 Crash rounds today & get ₹100 cashback.',
            '6/10',
            'https://api.builder.io/api/v1/image/assets/TEMP/6fda274d29785c477cdaa289219cc054be2b3518?width=40',
            const [Color(0xFF001C22)],
            const [Color(0x4D38DBFF), Color(0x0038DBFF)],
            const [Color(0x3338DBFF), Color(0x0038DBFF)],
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(
    double screenWidth,
    double screenHeight,
    String title,
    String progress,
    String iconUrl,
    List<Color> baseColors,
    List<Color> gradientColors1,
    List<Color> gradientColors2,
  ) {
    return Container(
      width: screenWidth * 0.91,
      margin: EdgeInsets.only(right: screenWidth * 0.037),
      padding: EdgeInsets.all(screenWidth * 0.047),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: baseColors.first,
        backgroundBlendMode: BlendMode.overlay,
        image: DecorationImage(
          image: const AssetImage('assets/images/card_pattern.png'),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: _getResponsiveFontSize(0.047, screenWidth),
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          SizedBox(height: screenHeight * 0.025),

          // Progress Bar
          Container(
            height: 14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withOpacity(0.1),
            ),
            child: Stack(
              children: [
                Container(
                  width: screenWidth * 0.47, // 60% progress
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.5),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF7EBF05), Color(0xFF29BF05)],
                      stops: [0.0, 0.585],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.025),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.network(
                    iconUrl,
                    width: iconUrl.contains('plane') ? 42 : 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: screenWidth * 0.023),
                  Text(
                    progress,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: _getResponsiveFontSize(0.033, screenWidth),
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.29,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.037,
                  vertical: screenHeight * 0.015,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: const Color(0xFFFFA500).withOpacity(0.4),
                  ),
                ),
                child: Text(
                  'Complete & Claim',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: _getResponsiveFontSize(0.028, screenWidth),
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInviteFriendsSection(double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.19,
      padding: EdgeInsets.all(screenWidth * 0.047),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const RadialGradient(
          center: Alignment.bottomLeft,
          radius: 2.0,
          colors: [Color(0xFF0484BF), Color(0xFF8BF837)],
          stops: [0.0, 1.0],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Invite friends & earn ₹50 per referral.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: _getResponsiveFontSize(0.047, screenWidth),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.028,
                        vertical: screenHeight * 0.011,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '9K1-2D5',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: _getResponsiveFontSize(
                                0.037,
                                screenWidth,
                              ),
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.023),
                          const Icon(Icons.copy, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.023),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.037,
                        vertical: screenHeight * 0.015,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xFFFFA500),
                      ),
                      child: Text(
                        'Invite',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: _getResponsiveFontSize(0.028, screenWidth),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF0B0F1A),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Image.network(
              'https://api.builder.io/api/v1/image/assets/TEMP/41ed9ca554e26bc6b3e4fec5f4a4b974df69caa8?width=236',
              width: 118,
              height: 110,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneRewardsSection(
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.047),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF271777),
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '120/',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: _getResponsiveFontSize(0.051, screenWidth),
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.27,
                        ),
                      ),
                      Text(
                        '500',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: _getResponsiveFontSize(0.033, screenWidth),
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.007),
                  Text(
                    'Games Played',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: _getResponsiveFontSize(0.023, screenWidth),
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.card_giftcard,
                        color: Color(0xFF928BBB),
                        size: 16,
                      ),
                      SizedBox(width: screenWidth * 0.014),
                      Text(
                        '₹200',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: _getResponsiveFontSize(0.051, screenWidth),
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.27,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.007),
                  Text(
                    'Next Reward',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: _getResponsiveFontSize(0.023, screenWidth),
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.025),

          // Progress Bar with segments
          Container(
            height: 14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.white.withOpacity(0.1),
            ),
            child: Stack(
              children: [
                // Bronze section (completed)
                Container(
                  width: screenWidth * 0.27, // ~116px on 348px container
                  height: 14,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                    gradient: LinearGradient(
                      colors: [Color(0xFFF17B4D), Color(0xFF8B472C)],
                    ),
                  ),
                ),
                // Current position indicator
                Positioned(
                  left: screenWidth * 0.27,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                      color: const Color(0xFFDEDEDE),
                    ),
                  ),
                ),
                // Silver section (not completed)
                Positioned(
                  left: screenWidth * 0.27 + 14 - 10,
                  child: Container(
                    width: screenWidth * 0.19, // ~80px
                    height: 14,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                        colors: [Color(0xFF787878), Color(0xFFDEDEDE)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.025),

          // Tier badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTierBadge(
                'Bronze',
                true,
                const Color(0xFFF17B4D),
                screenWidth,
              ),
              _buildTierBadge(
                'Silver',
                false,
                const Color(0xFF787878),
                screenWidth,
              ),
              _buildTierBadge(
                'Gold',
                false,
                const Color(0xFFEC9105),
                screenWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTierBadge(
    String tier,
    bool isActive,
    Color color,
    double screenWidth,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.023,
        vertical: screenWidth * 0.014,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isActive ? color : null,
        border: isActive ? null : Border.all(color: color),
        gradient: isActive
            ? null
            : LinearGradient(colors: [color.withOpacity(0.8), color]),
      ),
      child: Text(
        tier,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: _getResponsiveFontSize(0.023, screenWidth),
          fontWeight: FontWeight.w400,
          color: isActive ? Colors.white : color,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
