import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/payment/providers/user_transaction_provider.dart';

class BalanceCardWidget extends ConsumerStatefulWidget {
  const BalanceCardWidget({super.key});

  @override
  ConsumerState<BalanceCardWidget> createState() => _BalanceCardWidgetState();
}

class _BalanceCardWidgetState extends ConsumerState<BalanceCardWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userTransactionProvider.notifier).fetchUserTransactions(0, 10);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(userTransactionProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(23),
        width: double.infinity,
        // height: 165,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.walletFourthColor, width: 1),
          image: DecorationImage(
            image: AssetImage(AppImages.walletImage),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 32,
              width: 127,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.walletTenthColor),
                color: AppColors.walletEleventhColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  'Available Balance',
                  style: Theme.of(context).textTheme.walletBodySmallPrimary,
                ),
              ),
            ),
            SizedBox(height: 12),
            transactionState.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) {
                if (error is DioException &&
                    (error.type == DioExceptionType.connectionTimeout ||
                        error.type == DioExceptionType.receiveTimeout ||
                        error.type == DioExceptionType.sendTimeout ||
                        error.type == DioExceptionType.connectionError ||
                        error.type == DioExceptionType.unknown)) {
                  return const Text(
                    'Check Connectivity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return Text('Error: $error');
              },
              data: (response) {
                final wallet = response?.data.isNotEmpty == true
                    ? response!.data[0].user?.wallet ?? 0.0
                    : 0.0;
                return Text(
                  '₹${wallet.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.walletDisplaySmallPrimary,
                );
              },
            ),
            SizedBox(height: 6),
            Text(
              'Available to play & withdraw',
              style: Theme.of(context).textTheme.walletBodySmallPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
