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
            _buildStatusBar(),
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

  Widget _buildStatusBar() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '9:41',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro Text',
              ),
            ),
            Row(
              children: [
                Row(
                  children: List.generate(
                    4,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 2),
                      width: 3,
                      height: 4 + (index * 2).toDouble(),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.wifi, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                SizedBox(
                  width: 28,
                  height: 13,
                  child: Stack(
                    children: [
                      Container(
                        width: 25,
                        height: 13,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                          ),
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 4,
                        child: Container(
                          width: 2,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 2,
                        top: 2,
                        child: Container(
                          width: 21,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 24,
              ),
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
        ...guidelines.map((guideline) => Padding(
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
        )),
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
