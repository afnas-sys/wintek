import 'package:flutter/material.dart';

class HelpFaqScreen extends StatefulWidget {
  const HelpFaqScreen({super.key});

  @override
  State<HelpFaqScreen> createState() => _HelpFaqScreenState();
}

class _HelpFaqScreenState extends State<HelpFaqScreen>
    with TickerProviderStateMixin {
  final Map<int, bool> _expandedStates = {};
  final Map<int, AnimationController> _animationControllers = {};

  final List<FaqItem> _faqItems = [
    FaqItem(
      question: 'How do I withdraw money?',
      answer: 'Go to Wallet → Withdraw → Enter Bank/UPI details.',
    ),
    FaqItem(
      question: 'What if transaction fails?',
      answer:
          'If your transaction fails, the amount will be automatically refunded to your original payment method within 3-5 business days. You can also contact our support team for immediate assistance.',
    ),
    FaqItem(
      question: 'How do I add money to wallet?',
      answer:
          'You can add money to your wallet by going to Wallet → Add Money → Choose payment method (UPI/Card/Net Banking) → Enter amount and complete payment.',
    ),
    FaqItem(
      question: 'What are the withdrawal limits?',
      answer:
          'Minimum withdrawal amount is ₹100 and maximum is ₹50,000 per day. You can make up to 3 withdrawal requests per day.',
    ),
    FaqItem(
      question: 'Is my money safe?',
      answer:
          'Yes, your money is completely safe. We use bank-grade security with SSL encryption. All transactions are processed through secure payment gateways and we are fully compliant with RBI guidelines.',
    ),
    FaqItem(
      question: 'How long do withdrawals take?',
      answer:
          'UPI withdrawals are usually instant. Bank transfers take 1-2 hours during banking hours (9 AM - 6 PM) and up to 24 hours on weekends and holidays.',
    ),
    FaqItem(
      question: 'Can I cancel a withdrawal request?',
      answer:
          'You can cancel a withdrawal request only if it hasn\'t been processed yet. Go to Transaction History and check if the cancel option is available.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize animation controllers for all items
    for (int i = 0; i < _faqItems.length; i++) {
      _animationControllers[i] = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      // If item is initially expanded, set animation to completed
      if (_expandedStates[i] == true) {
        _animationControllers[i]!.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    // Dispose all animation controllers
    for (final controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleExpansion(int index) {
    setState(() {
      final isExpanded = _expandedStates[index] ?? false;
      _expandedStates[index] = !isExpanded;

      if (_expandedStates[index]!) {
        _animationControllers[index]!.forward();
      } else {
        _animationControllers[index]!.reverse();
      }
    });
  }

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
                  children: [..._buildFaqItems(), const SizedBox(height: 32)],
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
              child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Text(
              'Help & FAQ',
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

  List<Widget> _buildFaqItems() {
    return _faqItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isExpanded = _expandedStates[index] ?? false;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isExpanded ? Colors.white : Colors.white.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              // Question header with arrow
              GestureDetector(
                onTap: () => _toggleExpansion(index),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.question,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isExpanded ? 12 : 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: isExpanded ? 1.33 : 1.29,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedBuilder(
                        animation: _animationControllers[index]!,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle:
                                _animationControllers[index]!.value *
                                3.14159, // 180 degrees
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 18,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Expandable answer
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isExpanded
                    ? Container(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        width: double.infinity,
                        child: Text(
                          item.answer,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.43,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}
