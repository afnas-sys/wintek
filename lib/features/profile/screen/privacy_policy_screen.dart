import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
              'Privacy Policy',
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
        content: 'This Privacy Policy explains how we collect, use, and protect your personal information when you use our app.',
      ),
      _SectionData(
        title: 'Information We Collect',
        content: 'Personal details (Name, Email, Phone number, Date of Birth).\n\nPayment details (UPI ID, Bank details, Card information).\n\nGameplay data (Games played, wins/losses, in-app activity).\n\nDevice & usage info (IP address, OS, location).',
      ),
      _SectionData(
        title: 'How We Use Your Information',
        content: 'To verify your identity.\n\nTo process deposits & withdrawals.\n\nTo improve user experience & app features.\n\nTo send offers, rewards, and updates.\n\nFor fraud prevention & legal compliance.',
      ),
      _SectionData(
        title: 'Data Sharing & Disclosure',
        content: 'We do not sell your personal data.\nWe may share information with:',
        subContent: 'Payment partners (UPI, Banks, Wallets).\n\nLegal authorities (when required by law).\n\nService providers (for app analytics & customer support).',
      ),
      _SectionData(
        title: 'Data Security',
        content: 'Your data is protected using encryption & secure servers.\n\nWe regularly audit our systems for vulnerabilities.\n\nHowever, no online system is 100% secure, so users must also play responsibly.',
      ),
      _SectionData(
        title: 'Cookies & Tracking',
        content: 'We may use cookies to enhance user experience.\n\nYou can disable cookies in your device settings.',
      ),
      _SectionData(
        title: 'User Rights',
        content: 'You can update or correct your personal details anytime in your Profile.\n\nYou may request deletion of your account & data by contacting support.\n\nYou can opt-out of marketing emails & notifications.',
      ),
    ];

    return sections.expand((section) => [
      _buildSection(section.title, section.content, section.subContent),
      const SizedBox(height: 24),
    ]).toList();
  }

  Widget _buildSection(String title, String content, [String? subContent]) {
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
        if (subContent != null) ...[
          const SizedBox(height: 12),
          Text(
            subContent,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionData {
  final String title;
  final String content;
  final String? subContent;

  _SectionData({required this.title, required this.content, this.subContent});
}
