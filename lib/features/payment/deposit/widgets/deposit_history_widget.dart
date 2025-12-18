import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/payment/providers/user_transaction_provider.dart';

class DepositHistoryWidget extends ConsumerStatefulWidget {
  const DepositHistoryWidget({super.key});

  @override
  ConsumerState<DepositHistoryWidget> createState() =>
      _DepositHistoryWidgetState();
}

class _DepositHistoryWidgetState extends ConsumerState<DepositHistoryWidget> {
  String selectedStatus = 'All';
  bool _showAll = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userTransactionProvider.notifier).fetchAllUserTransactions();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 26),
      decoration: const BoxDecoration(
        color: AppColors.paymentFourteenthColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHistoryHeader(context),
          const SizedBox(height: 24),
          _buildHistoryTableHeader(context),
          const SizedBox(height: 16),
          _buildDashedDivider(),
          const SizedBox(height: 16),
          _buildHistoryList(),
        ],
      ),
    );
  }

  Widget _buildHistoryHeader(BuildContext context) {
    final trasactionState = ref.watch(userTransactionProvider);
    String totalText = 'Deposit History';
    trasactionState.when(
      loading: () => totalText = 'Deposit History',
      error: (error, stack) => totalText = 'Deposit History',
      data: (data) {
        if (data != null) {
          final filtered = data.data
              .where((transaction) => transaction.transferType == 'upi')
              .toList();
          totalText = 'Deposit History (${filtered.length})';
        }
      },
    );
    return Row(
      children: [
        Expanded(
          child: Text(
            totalText,
            style: Theme.of(context).textTheme.paymentTitleMediumPrimary,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (String value) {
            setState(() {
              selectedStatus = value;
            });
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'All',
              child: Text(
                'All',
                style: TextStyle(
                  color: selectedStatus == 'All'
                      ? AppColors.paymentPrimaryColor
                      : AppColors.aviatorEleventhColor,
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'pending',
              child: Text(
                'Pending',
                style: TextStyle(
                  color: selectedStatus == 'pending'
                      ? AppColors.paymentPrimaryColor
                      : AppColors.aviatorEleventhColor,
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'success',
              child: Text(
                'Success',
                style: TextStyle(
                  color: selectedStatus == 'success'
                      ? AppColors.paymentPrimaryColor
                      : AppColors.aviatorEleventhColor,
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'failed',
              child: Text(
                'Failed',
                style: TextStyle(
                  color: selectedStatus == 'failed'
                      ? AppColors.paymentPrimaryColor
                      : AppColors.aviatorEleventhColor,
                ),
              ),
            ),
          ],
          child: Container(
            height: 44,
            width: 44,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppColors.paymentSixteenthColor),
              image: DecorationImage(
                image: AssetImage(AppImages.linearSetting),
              ),
            ),
            // child: const Icon(Icons.tune, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTableHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              'Amount',
              style: Theme.of(context).textTheme.paymentBodySmallSecondary,
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              'Date',
              style: Theme.of(context).textTheme.paymentBodySmallSecondary,
            ),
          ),
          SizedBox(
            width: 74,
            child: Text(
              'Status',
              style: Theme.of(context).textTheme.paymentBodySmallSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return DottedLine(
      dashColor: AppColors.paymentEighteenthColor,
      dashLength: 8,
      dashGapLength: 4,
      lineThickness: 1,
    );
  }

  Widget _buildHistoryList() {
    final trasactionState = ref.watch(userTransactionProvider);

    return trasactionState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        if (error is DioException &&
            (error.type == DioExceptionType.connectionTimeout ||
                error.type == DioExceptionType.receiveTimeout ||
                error.type == DioExceptionType.sendTimeout ||
                error.type == DioExceptionType.connectionError ||
                error.type == DioExceptionType.unknown)) {
          return const Center(
            child: Text(
              'Check Connectivity',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return Center(child: Text(error.toString()));
      },
      data: (data) {
        if (data == null || data.data.isEmpty) {
          return Center(
            child: Text(
              'No history found',
              style: Theme.of(context).textTheme.paymentBodySmallThird,
            ),
          );
        }
        final depositData = data.data
            .where((transaction) => transaction.transferType == 'upi')
            .toList();
        final filteredData = selectedStatus == 'All'
            ? depositData
            : depositData
                  .where((transaction) => transaction.status == selectedStatus)
                  .toList();
        if (filteredData.isEmpty) {
          return Center(
            child: Text(
              'No history found for selected status',
              style: Theme.of(context).textTheme.paymentSmallSecondary,
            ),
          );
        }
        final displayedData = _showAll
            ? filteredData
            : filteredData.take(10).toList();
        return Column(
          children: [
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: displayedData.length,
              separatorBuilder: (context, index) => Column(
                children: [
                  const SizedBox(height: 20),
                  DottedLine(
                    dashColor: AppColors.paymentEighteenthColor,
                    dashLength: 8,
                    dashGapLength: 4,
                    lineThickness: 1,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              itemBuilder: (context, index) {
                final transaction = displayedData[index];
                return _buildHistoryItem(
                  transaction.amount.toStringAsFixed(2),
                  DateFormat('dd MMM, hh:mm a').format(
                    DateTime.parse(
                      transaction.createdAt,
                    ).add(const Duration(hours: 5, minutes: 30)),
                  ),
                  transaction.status,
                  context,
                );
              },
            ),
            if (filteredData.length > 10 && !_showAll)
              Center(
                child: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onPressed: () {
                    setState(() {
                      _showAll = true;
                    });
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHistoryItem(
    String amount,
    String date,
    String status,
    BuildContext context,
  ) {
    Color statusColor;
    switch (status) {
      case 'pending':
        statusColor = AppColors.paymentNinteenthColor;
        break;
      case 'success':
        statusColor = AppColors.paymentTwentythColor;
        break;
      case 'failed':
        statusColor = AppColors.paymentTwentyfirstColor;
        break;
      default:
        statusColor = AppColors.paymentFifteenthColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              amount,
              style: Theme.of(context).textTheme.paymentSmallSecondary,
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              date,
              style: Theme.of(context).textTheme.paymentSmallSecondary,
            ),
          ),
          SizedBox(
            width: 74,
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
