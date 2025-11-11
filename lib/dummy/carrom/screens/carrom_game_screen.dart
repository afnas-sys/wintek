import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/dummy/carrom/screens/carrom_match_fixing%20_screen.dart';

class CarromGameScreen extends StatelessWidget {
  const CarromGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140A2D),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    _buildGameModeCard(
                      context,
                      CarromMatchFixingScreen(),
                      image: AppImages.carrom1v1,
                    ),
                    const SizedBox(height: 16),
                    _buildGameModeCard(
                      context,
                      CarromMatchFixingScreen(),
                      image: AppImages.carromTournament,
                    ),
                    const SizedBox(height: 16),
                    _buildGameModeCard(
                      context,
                      CarromMatchFixingScreen(),
                      image: AppImages.carromPractice,
                    ),

                    ///////
                    const SizedBox(height: 20),
                    _buildRecentWinnersSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Text(
              'Carrom',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Text(
              'Active 324',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameModeCard(
    BuildContext context,
    CarromMatchFixingScreen match, {
    required String image,
  }) {
    return GestureDetector(
      onDoubleTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => match),
      ),
      child: Container(
        width: 388,
        height: 156,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildRecentWinnersSection() {
    final winners = [
      WinnerData(
        name: 'Ankit',
        prize: '₹200',
        time: '3:45 PM',
        imageUrl:
            'https://api.builder.io/api/v1/image/assets/TEMP/5463c80d897ffc262dada648a0c8eeac49fddfbe?width=68',
      ),
      WinnerData(
        name: 'Neha',
        prize: '₹100',
        time: '3:30 PM',
        imageUrl:
            'https://api.builder.io/api/v1/image/assets/TEMP/c349ef67b2d543f047ffbae8260742c836a786c6?width=68',
      ),
      WinnerData(
        name: 'Sameer',
        prize: '₹80',
        time: '3:20 PM',
        imageUrl:
            'https://api.builder.io/api/v1/image/assets/TEMP/2143f08bb13abbb7105a663577cb81c549e9a707?width=68',
      ),
      WinnerData(
        name: 'Ankit',
        prize: '₹200',
        time: '3:45 PM',
        imageUrl:
            'https://api.builder.io/api/v1/image/assets/TEMP/65af83f87129e13b08ea73cc34a8eb2115680c5b?width=68',
      ),
      WinnerData(
        name: 'Ankit',
        prize: '₹200',
        time: '3:45 PM',
        imageUrl:
            'https://api.builder.io/api/v1/image/assets/TEMP/65af83f87129e13b08ea73cc34a8eb2115680c5b?width=68',
      ),
      WinnerData(
        name: 'Neha',
        prize: '₹100',
        time: '3:30 PM',
        imageUrl:
            'https://api.builder.io/api/v1/image/assets/TEMP/c349ef67b2d543f047ffbae8260742c836a786c6?width=68',
      ),
      WinnerData(
        name: 'Sameer',
        prize: '₹80',
        time: '3:20 PM',
        imageUrl:
            'https://api.builder.io/api/v1/image/assets/TEMP/e693ccb83db7030cae432478ffb891b617cae5c9?width=68',
      ),
      WinnerData(
        name: 'Ankit',
        prize: '₹200',
        time: '3:45 PM',
        imageUrl:
            'https://api.builder.io/api/v1/image/assets/TEMP/2143f08bb13abbb7105a663577cb81c549e9a707?width=68',
      ),
    ];

    return Container(
      width: 388,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        color: const Color(0xFF6041FF).withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Winners',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.33,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFE5E5E5).withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: winners.length,
            itemBuilder: (context, index) {
              final winner = winners[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildWinnerItem(winner),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWinnerItem(WinnerData winner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: NetworkImage(winner.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              winner.name,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            'Won ${winner.prize} at ${winner.time}',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class WinnerData {
  final String name;
  final String prize;
  final String time;
  final String imageUrl;

  WinnerData({
    required this.name,
    required this.prize,
    required this.time,
    required this.imageUrl,
  });
}
