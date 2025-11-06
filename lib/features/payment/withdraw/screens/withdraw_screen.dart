import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/features/payment/widgets/balance_card_widget.dart';
import 'package:wintek/features/payment/widgets/payment_appbar.dart';
import 'package:wintek/features/payment/withdraw/widgets/withdraw_form_field_widget.dart';
import 'package:wintek/features/payment/withdraw/widgets/withdraw_note_widget.dart';
import 'package:wintek/features/payment/withdraw/widgets/withdraw_history_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/payment/providers/user_transaction_provider.dart';

class WithdrawScreen extends ConsumerWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.paymentTwentysecondColor,
      appBar: paymentAppBar(context, 'Withdraw'),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(userTransactionProvider.notifier)
                  .fetchAllUserTransactions();
              await ref
                  .read(userTransactionProvider.notifier)
                  .fetchUserTransactions(0, 10);
            },
            child: SingleChildScrollView(
              child: Column(
                spacing: 20,
                children: [
                  BalanceCardWidget(),

                  WithdrawFormFieldWidget(),

                  SizedBox(
                    //   height: 348,
                    child: Stack(
                      children: [
                        WithdrawNoteWidget(),
                        Padding(
                          padding: const EdgeInsets.only(top: 55),
                          child: WithdrawHistoryWidget(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
