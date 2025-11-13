import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/features/payment/providers/user_transaction_provider.dart';

class TransactionHistory extends ConsumerStatefulWidget {
  const TransactionHistory({super.key});

  @override
  ConsumerState<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends ConsumerState<TransactionHistory> {
  String selectedStatus = 'All';
  final bool _showAll = false;

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
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        color: AppColors.walletThirteenthColor,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Transaction History',
                style: Theme.of(context).textTheme.walletTitleMediumPrimary,
              ),
              Spacer(),
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
                  PopupMenuItem<String>(
                    value: 'completed',
                    child: Text(
                      'Completed',
                      style: TextStyle(
                        color: selectedStatus == 'completed'
                            ? AppColors.paymentPrimaryColor
                            : AppColors.aviatorEleventhColor,
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'cancelled',
                    child: Text(
                      'Cancelled',
                      style: TextStyle(
                        color: selectedStatus == 'cancelled'
                            ? AppColors.paymentPrimaryColor
                            : AppColors.aviatorEleventhColor,
                      ),
                    ),
                  ),
                ],
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.walletFourteenthColor),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.asset(
                    AppImages.linearSetting,
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            lineThickness: 1.0,
            dashLength: 4.0,
            dashColor: AppColors.walletFifteenthColor,
          ),
          Consumer(
            builder: (context, ref, child) {
              final trasactionState = ref.watch(userTransactionProvider);
              return trasactionState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text(error.toString())),
                data: (data) {
                  if (data == null || data.data.isEmpty) {
                    return const Center(child: Text('No history found'));
                  }
                  final allTransactions = data.data
                      .where(
                        (transaction) =>
                            transaction.transferType == 'upi' ||
                            transaction.transferType == 'withdrawal',
                      )
                      .toList();
                  final filteredData = selectedStatus == 'All'
                      ? allTransactions
                      : allTransactions
                            .where(
                              (transaction) =>
                                  transaction.status == selectedStatus,
                            )
                            .toList();
                  final displayedData = _showAll
                      ? filteredData
                      : filteredData.take(10).toList();
                  if (displayedData.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 210),
                        child: Text(
                          'No history found',
                          style: Theme.of(
                            context,
                          ).textTheme.walletBodyMediumPrimary,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayedData.length,
                    separatorBuilder: (context, index) {
                      return DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 4.0,
                        dashColor: AppColors.walletFifteenthColor,
                      );
                    },
                    itemBuilder: (context, index) {
                      final transaction = displayedData[index];
                      final isDeposit = transaction.transferType == 'upi';

                      final image = isDeposit
                          ? AppImages.receive
                          : AppImages.send;
                      final borderColor = isDeposit
                          ? AppColors.walletThirdColor
                          : AppColors.walletSixteenthColor;
                      final title = isDeposit ? 'Deposit' : 'Withdraw';
                      final statusColor =
                          (transaction.status == 'success' ||
                              transaction.status == 'completed')
                          ? AppColors.walletSecondaryColor
                          : (transaction.status == 'pending'
                                ? AppColors.paymentNinteenthColor
                                : AppColors.walletSeventeenthColor);

                      String amountPrefix;
                      Color amountColor;
                      if (transaction.status == 'pending') {
                        amountColor = AppColors.walletSeventeenthColor;
                        amountPrefix = isDeposit ? '+ ' : '- ';
                      } else if (isDeposit) {
                        amountPrefix = '+ ';
                        amountColor = AppColors.walletSecondaryColor;
                      } else {
                        // Withdrawal
                        if (transaction.status == 'failed' ||
                            transaction.status == 'cancelled') {
                          amountPrefix = '+ ';
                          amountColor = AppColors.walletSeventeenthColor;
                        } else {
                          amountPrefix = '- ';
                          amountColor = AppColors.walletSecondaryColor;
                        }
                      }

                      return ListTile(
                        leading: Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.asset(image, height: 16, width: 16),
                        ),
                        title: Text(
                          title,
                          style: Theme.of(
                            context,
                          ).textTheme.walletBodyMediumPrimary,
                        ),
                        subtitle: Text(
                          DateFormat('dd MMM, hh:mm a').format(
                            DateTime.parse(
                              transaction.createdAt,
                            ).add(const Duration(hours: 5, minutes: 30)),
                          ),
                          style: Theme.of(
                            context,
                          ).textTheme.walletBodySmallPrimary,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '$amountPrefix₹${transaction.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: amountColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              transaction.status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
