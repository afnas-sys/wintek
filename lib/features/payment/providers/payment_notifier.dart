import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/payment/domain/models/transfer_request_model.dart';
import 'package:wintek/features/payment/domain/models/transfer_response_model.dart';
import 'package:wintek/features/payment/services/payment_services.dart';

class PaymentState {
  final bool isLoading;
  final String? message;

  PaymentState({this.isLoading = false, this.message});

  PaymentState copyWith({bool? isLoading, String? message}) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentServices _paymentServices;
  final SecureStorageService _storage;

  PaymentNotifier(this._paymentServices, this._storage) : super(PaymentState());

  Future<TransferResponseModel?> createTransaction(
    TransferRequestModel request,
    BuildContext context,
  ) async {
    state = PaymentState(isLoading: true, message: null);
    try {
      final credentials = await _storage.readCredentials();
      if (credentials.token == null) {
        state = PaymentState(isLoading: false, message: 'No token found');
        return null;
      }

      final response = await _paymentServices.createTransaction(request);

      state = PaymentState(isLoading: false, message: response.message);

      // Show message in ScaffoldMessenger
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: response.status == 'success'
              ? Colors.green
              : Colors.red,
        ),
      );

      return response;
    } catch (e) {
      final errorMessage = e is Map
          ? e['message'] ?? 'Unknown error'
          : e.toString();
      state = PaymentState(isLoading: false, message: errorMessage);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );

      log('Payment error: $errorMessage');
      return null;
    }
  }
}

final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
      return PaymentNotifier(
        ref.read(paymentServicesProvider),
        SecureStorageService(),
      );
    });
