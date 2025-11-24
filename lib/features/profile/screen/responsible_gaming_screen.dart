import 'package:flutter/material.dart';

class ResponsibleGamingScreen extends StatelessWidget {
  const ResponsibleGamingScreen({super.key});

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
              'Responsible Gaming',
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
    return [
      _buildSection(
        'Intro Section',
        'We want gaming to be fun and safe. Please play responsibly and within your limits.',
      ),
      const SizedBox(height: 24),
      _buildGuidelinesSection(),
      const SizedBox(height: 24),
      _buildSection(
        'Tools & Features (In-App Controls)',
        'Daily Deposit Limit → Example: ₹500 / ₹2000\n\nSelf-Exclusion → Temporarily suspend your account for 7 days / 30 days / 90 days.\n\nTime Reminders → Notification if you play for more than 1 hour continuously.',
      ),
      const SizedBox(height: 24),
      _buildSupportSection(),
      const SizedBox(height: 24),
      _buildSection(
        'Footer Note',
        'Our goal is to provide a fun and safe gaming environment. Please gamble responsibly.',
      ),
    ];
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

  Widget _buildGuidelinesSection() {
    final guidelines = [
      'Play for entertainment, not as a source of income.',
      'Set a budget before you play and stick to it.',
      'Take regular breaks between sessions.',
      'Avoid playing when stressed, tired, or under influence.',
      'Never borrow money to play.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Guidelines (Bullet Points)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.375,
          ),
        ),
        const SizedBox(height: 12),
        ...guidelines.map(
          (guideline) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '✅ $guideline',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Support for Gaming Addiction',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.375,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'If you feel gaming is becoming a problem, reach out for help.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Resources:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '📞 Helpline: 1800-123-4567\n\n📧 Email: rg-support@gamehub.com\n\n🌐 Website: www.responsiblegaming.org',
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
