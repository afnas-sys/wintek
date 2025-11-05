import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/services/secure_storage.dart';
import 'package:wintek/features/payment/deposit/domain/models/deposit_request_model.dart';
import 'package:wintek/features/payment/domain/models/transfer_response_model.dart';
import 'package:wintek/features/payment/deposit/services/deposit_services.dart';

class DepositState {
  final bool isLoading;
  final String? message;

  DepositState({this.isLoading = false, this.message});

  DepositState copyWith({bool? isLoading, String? message}) {
    return DepositState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }
}

class DepositNotifier extends StateNotifier<DepositState> {
  final DepositServices _paymentServices;
  final SecureStorageService _storage;

  DepositNotifier(this._paymentServices, this._storage) : super(DepositState());

  Future<TransferResponseModel?> createTransaction(
    DepositRequestModel request,
    BuildContext context,
  ) async {
    state = DepositState(isLoading: true, message: null);
    try {
      final credentials = await _storage.readCredentials();
      if (credentials.token == null) {
        state = DepositState(isLoading: false, message: 'No token found');
        return null;
      }

      final response = await _paymentServices.createTransaction(request);

      state = DepositState(isLoading: false, message: response.message);

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
      state = DepositState(isLoading: false, message: errorMessage);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );

      log('Payment error: $errorMessage');
      return null;
    }
  }
}

final depositNotifierProvider =
    StateNotifierProvider<DepositNotifier, DepositState>((ref) {
      return DepositNotifier(
        ref.read(depositServicesProvider),
        SecureStorageService(),
      );
    });
