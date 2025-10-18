import 'package:flutter/material.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140A2D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusBar(),
              const SizedBox(height: 16),
              _buildHeader(context),
              const SizedBox(height: 30),
              _buildDescription(),
              const SizedBox(height: 20),
              _buildCustomerSupportSection(),
              const SizedBox(height: 16),
              _buildSocialMediaSection(),
              const SizedBox(height: 30),
              _buildLiveChatSection(),
              const SizedBox(height: 32),
            ],
          ),
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
                // Signal bars
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
                // WiFi icon
                const Icon(Icons.wifi, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                // Battery
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
              width: 42,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Text(
              'Contact Support',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Text(
        'You can get in touch with us through below platforms. Our Team will reach out to you as soon as it would be possible',
        style: TextStyle(
          color: Color(0x80FFFFFF),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          height: 1.43,
        ),
      ),
    );
  }

  Widget _buildCustomerSupportSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF271358),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Support',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
          const SizedBox(height: 20),
          _buildContactItem(
            icon: _buildPhoneIcon(),
            label: 'Contact Number',
            value: '+91 98765 43210',
          ),
          const SizedBox(height: 30),
          _buildContactItem(
            icon: _buildEmailIcon(),
            label: 'Email Address',
            value: '+91 98765 43210',
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF271358),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Social Media',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
          const SizedBox(height: 20),
          _buildContactItem(
            icon: _buildInstagramIcon(),
            label: 'Instagram',
            value: '@pixelsurfer',
          ),
          const SizedBox(height: 30),
          _buildContactItem(
            icon: _buildTwitterIcon(),
            label: 'Twitter',
            value: '@pixelsurfer',
          ),
          const SizedBox(height: 30),
          _buildContactItem(
            icon: _buildFacebookIcon(),
            label: 'Facebook',
            value: '@pixelsurfer',
          ),
        ],
      ),
    );
  }

  Widget _buildLiveChatSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text(
            'Live Chat & Call',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Chat with our live representative.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xB3FFFFFF),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.29,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle live chat action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA82E),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Start Live Chat',
                style: TextStyle(
                  color: Color(0xFF0B0F1A),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 10),
              const Text(
                'All Conversations are safe & private.',
                style: TextStyle(
                  color: Color(0xB3FFFFFF),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.29,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required Widget icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0x80FFFFFF),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneIcon() {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0x3300FF6A),
          width: 1,
        ),
      ),
      child: const Icon(
        Icons.phone,
        color: Color(0xFF00FF6A),
        size: 16,
      ),
    );
  }

  Widget _buildEmailIcon() {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0x3300FF6A),
          width: 1,
        ),
      ),
      child: const Icon(
        Icons.email_outlined,
        color: Color(0xFF00FF6A),
        size: 16,
      ),
    );
  }

  Widget _buildInstagramIcon() {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0x3300FF6A),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.camera_alt,
        color: const Color(0xFF00FF6A),
        size: 16,
      ),
    );
  }

  Widget _buildTwitterIcon() {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0x3300FF6A),
          width: 1,
        ),
      ),
      child: const Text(
        'X',
        style: TextStyle(
          color: Color(0xFF00FF6A),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFacebookIcon() {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0x3300FF6A),
          width: 1,
        ),
      ),
      child: const Text(
        'f',
        style: TextStyle(
          color: Color(0xFF00FF6A),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
