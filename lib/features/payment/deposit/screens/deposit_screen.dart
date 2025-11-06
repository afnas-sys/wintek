import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/payment/deposit/widgets/deposit_amount_field_widget.dart';
import 'package:wintek/features/payment/deposit/widgets/deposit_history_widget.dart';
import 'package:wintek/features/payment/deposit/widgets/deposit_note_widget.dart';
import 'package:wintek/features/payment/deposit/widgets/deposit_payment_section_widget.dart';
import 'package:wintek/features/payment/providers/user_transaction_provider.dart';
import 'package:wintek/features/payment/widgets/balance_card_widget.dart';
import 'package:wintek/features/payment/widgets/payment_appbar.dart';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});

  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  final TextEditingController _amountController = TextEditingController();

  Future<void> _onRefresh() async {
    await ref.read(userTransactionProvider.notifier).fetchAllUserTransactions();
    await ref
        .read(userTransactionProvider.notifier)
        .fetchUserTransactions(0, 10);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: paymentAppBar(context, 'Deposit'),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Column(
                spacing: 20,
                children: [
                  const BalanceCardWidget(),

                  DepositAmountFieldWidget(controller: _amountController),

                  DepositPaymentSectionWidget(controller: _amountController),

                  SizedBox(
                    //      height: 348,
                    child: Stack(
                      children: [
                        DepositNoteWidget(),
                        Padding(
                          padding: const EdgeInsets.only(top: 55),
                          child: DepositHistoryWidget(),
                        ),
                      ],
                    ),
                  ),
                  //    LayoutBuilder(
                  //   builder: (context, constraints) {
                  //     return Column(
                  //       children: [
                  //         Stack(
                  //           clipBehavior: Clip.none,
                  //           children: [
                  //             // DepositNoteWidget (acts as background or header)
                  //             DepositNoteWidget(),

                  //             // History list positioned below the note widget
                  //             Padding(
                  //               padding: const EdgeInsets.only(top: 55),
                  //               child: DepositHistoryWidget(),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
