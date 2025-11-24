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
        content:
            'This Privacy Policy explains how we collect, use, and protect your personal information when you use our app.',
      ),
      _SectionData(
        title: 'Information We Collect',
        content:
            'Personal details (Name, Email, Phone number, Date of Birth).\n\nPayment details (UPI ID, Bank details, Card information).\n\nGameplay data (Games played, wins/losses, in-app activity).\n\nDevice & usage info (IP address, OS, location).',
      ),
      _SectionData(
        title: 'How We Use Your Information',
        content:
            'To verify your identity.\n\nTo process deposits & withdrawals.\n\nTo improve user experience & app features.\n\nTo send offers, rewards, and updates.\n\nFor fraud prevention & legal compliance.',
      ),
      _SectionData(
        title: 'Data Sharing & Disclosure',
        content:
            'We do not sell your personal data.\nWe may share information with:',
        subContent:
            'Payment partners (UPI, Banks, Wallets).\n\nLegal authorities (when required by law).\n\nService providers (for app analytics & customer support).',
      ),
      _SectionData(
        title: 'Data Security',
        content:
            'Your data is protected using encryption & secure servers.\n\nWe regularly audit our systems for vulnerabilities.\n\nHowever, no online system is 100% secure, so users must also play responsibly.',
      ),
      _SectionData(
        title: 'Cookies & Tracking',
        content:
            'We may use cookies to enhance user experience.\n\nYou can disable cookies in your device settings.',
      ),
      _SectionData(
        title: 'User Rights',
        content:
            'You can update or correct your personal details anytime in your Profile.\n\nYou may request deletion of your account & data by contacting support.\n\nYou can opt-out of marketing emails & notifications.',
      ),
    ];

    return sections
        .expand(
          (section) => [
            _buildSection(section.title, section.content, section.subContent),
            const SizedBox(height: 24),
          ],
        )
        .toList();
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
