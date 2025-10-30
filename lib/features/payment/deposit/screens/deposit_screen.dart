import 'package:flutter/material.dart';
import 'package:wintek/features/payment/deposit/widgets/deposit_amount_field_widget.dart';
import 'package:wintek/features/payment/deposit/widgets/deposit_history_widget.dart';
import 'package:wintek/features/payment/deposit/widgets/deposit_note_widget.dart';
import 'package:wintek/features/payment/deposit/widgets/deposit_payment_section_widget.dart';
import 'package:wintek/features/payment/widgets/balance_card_widget.dart';
import 'package:wintek/features/payment/widgets/payment_appbar.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: paymentAppBar(context, 'Deposit'),

      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              children: [
                const BalanceCardWidget(),

                DepositAmountFieldWidget(),

                DepositPaymentSectionWidget(),

                SizedBox(
                  height: 348,
                  child: Stack(
                    children: [
                      DepositNoteWidget(),
                      Positioned(
                        top: 55,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: DepositHistoryWidget(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
