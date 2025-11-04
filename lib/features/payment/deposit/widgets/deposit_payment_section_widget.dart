import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_upi_india/flutter_upi_india.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/payment/domain/models/deposit_request_model.dart';
import 'package:wintek/features/payment/providers/payment_notifier.dart';

class DepositPaymentSectionWidget extends ConsumerStatefulWidget {
  final TextEditingController controller;

  const DepositPaymentSectionWidget({super.key, required this.controller});

  @override
  ConsumerState<DepositPaymentSectionWidget> createState() =>
      _DepositPaymentSectionWidgetState();
}

class _DepositPaymentSectionWidgetState
    extends ConsumerState<DepositPaymentSectionWidget> {
  String status = 'Ready';
  bool _loading = false;

  // ✅ Replace with your actual UPI ID and receiver name
  final String receiverUpiAddress = 'yourrealupi@okicici';
  final String receiverName = 'Test Merchant';

  final String currency = 'INR';

  final SecureStorageService _storage = SecureStorageService();

  // Hardcoded apps
  final List<Map<String, dynamic>> upiApps = [
    {'name': 'Google', 'app': UpiApplication.googlePay, 'icon': AppImages.gpay},
    {
      'name': 'PhonePe',
      'app': UpiApplication.phonePe,
      'icon': AppImages.phonepay,
    },
    {'name': 'Paytm', 'app': UpiApplication.paytm, 'icon': AppImages.paytm},
  ];

  // UPI apps that use flutter_upi_india package
  final List<String> packageApps = ['Google', 'Paytm'];

  Future<void> _payWith(Map<String, dynamic> app) async {
    final name = app['name'];
    final upiApp = app['app'] as UpiApplication;

    setState(() {
      _loading = true;
      status = 'Opening $name...';
    });

    try {
      // ✅ Use flutter_upi_india package for all apps
      final response = await UpiPay.initiateTransaction(
        app: upiApp,
        receiverUpiAddress: receiverUpiAddress,
        receiverName: receiverName,
        transactionRef: 'TR${DateTime.now().millisecondsSinceEpoch}',
        amount: widget.controller.text,
      );
      if (response.status == UpiTransactionStatus.success) {
        _showSnack('Payment successful via $name', Colors.green);

        // call Api
        await _callTransactionAPI('success');
      } else {
        _showSnack('Payment failed or cancelled', Colors.red);
        // dont call api
        await _callTransactionAPI('failure');
      }
    } catch (e) {
      _showSnack('Error: $e', Colors.red);
    } finally {
      setState(() {
        _loading = false;
        status = 'Ready';
      });
    }
  }

  Future<void> _callTransactionAPI(String status) async {
    try {
      final credentials = await _storage.readCredentials();
      final taxId = 'HDF${DateTime.now().millisecondsSinceEpoch}';
      final refId = 'REF${DateTime.now().millisecondsSinceEpoch}';
      if (credentials.userId == null) {
        _showSnack('User not logged in', Colors.red);
        return;
      }
      final request = DepositRequestModel(
        userId: credentials.userId!,
        transferType: 'upi',
        amount: double.parse(widget.controller.text),
        type: 'mobile',
        note: '',
        status: status,
        taxId: taxId,
        refId: refId,
      );

      if (status == 'success') {
        final paymentNotifier = ref.read(depositNotifierProvider.notifier);
        final response = await paymentNotifier.createTransaction(
          request,
          context,
        );
        log('Payment API response: ${response?.message}');
      } else {
        log('Skipping API call: payment was not successful');
      }
    } catch (e) {
      _showSnack('Failed to create transaction: $e', Colors.red);
    }
  }

  void _showSnack(String msg, Color bg) {
    log('msg: $msg');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: bg));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Payment Method',
            style: Theme.of(context).textTheme.paymentSmallPrimary,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: upiApps
                  .asMap()
                  .entries
                  .map((entry) {
                    final app = entry.value;
                    final index = entry.key;
                    return [
                      _buildPaymentMethod(
                        app['name'],
                        app['icon'],
                        context,
                        app,
                      ),
                      if (index < upiApps.length - 1)
                        Container(
                          width: 1,
                          height: 80,
                          color: AppColors.paymentSecondaryColor,
                        ),
                    ];
                  })
                  .expand((element) => element)
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(
    String name,
    String image,
    BuildContext context,
    Map<String, dynamic> app,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: _loading ? null : () => _payWith(app),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(image)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: Theme.of(context).textTheme.paymentSmallSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
