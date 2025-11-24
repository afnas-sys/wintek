import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140A2D),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildHeader(context),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLastUpdated(),
                    const SizedBox(height: 24),
                    ..._buildSections(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const SizedBox(
              width: 48,
              child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
            ),
          ),
          const Expanded(
            child: Text(
              'Terms & Conditions',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildLastUpdated() {
    return Text(
      'Last Updated: 02 Sep 2025',
      style: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
    );
  }

  List<Widget> _buildSections() {
    final sections = [
      _SectionData(
        title: 'Introduction',
        content:
            'Welcome to our app! By creating an account or using our services, you agree to these Terms & Conditions. Please read them carefully.',
      ),
      _SectionData(
        title: 'Eligibility',
        content:
            'You must be 18 years or older to play real-money games.\n\nYou confirm that you are playing from a legally allowed region.',
      ),
      _SectionData(
        title: 'User Responsibilities',
        content:
            'Do not create multiple accounts.\n\nDo not use cheats, hacks, or unfair practices.\n\nYou are responsible for the accuracy of information you provide.',
      ),
      _SectionData(
        title: 'Deposits & Withdrawals',
        content:
            'All deposits are final.\n\nWithdrawals may take 1–3 business days to process.\n\nThe company reserves the right to verify identity before processing withdrawals.',
      ),
      _SectionData(
        title: 'Game Rules',
        content:
            'Each game (Aviator, Crash, Carrom, Spin & Win, Card Jackpot) follows its own rules, shown inside the app.\n\nThe company is not responsible for network issues during gameplay.',
      ),
      _SectionData(
        title: 'Rewards & Offers',
        content:
            'Bonuses and offers are subject to change or cancellation without prior notice.\n\nFraudulent use of offers may result in account suspension.',
      ),
      _SectionData(
        title: 'Responsible Gaming',
        content:
            'Play responsibly and within your limits.\n\nWe encourage breaks and setting deposit limits.\n\nIf you feel addicted, please contact our support team.',
      ),
      _SectionData(
        title: 'Account Suspension / Termination',
        content:
            'Violation of rules may lead to temporary or permanent account suspension.\n\nFraudulent activity will result in account termination.',
      ),
    ];

    return sections
        .expand(
          (section) => [
            _buildSection(section.title, section.content),
            const SizedBox(height: 24),
          ],
        )
        .toList();
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.375,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _SectionData {
  final String title;
  final String content;

  _SectionData({required this.title, required this.content});
}
