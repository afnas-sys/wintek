import 'package:flutter/material.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/features/payment/widgets/balance_card_widget.dart';
import 'package:wintek/features/payment/widgets/payment_appbar.dart';
import 'package:wintek/features/payment/withdraw/widgets/withdraw_form_field_widget.dart';
import 'package:wintek/features/payment/withdraw/widgets/withdraw_note_widget.dart';
import 'package:wintek/features/payment/withdraw/widgets/withdraw_history_widget.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paymentTwentysecondColor,
      appBar: paymentAppBar(context, 'Withdraw'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              BalanceCardWidget(),

              WithdrawFormFieldWidget(),

              SizedBox(
                height: 348,
                child: Stack(
                  children: [
                    WithdrawNoteWidget(),
                    Positioned(
                      top: 85,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: WithdrawHistoryWidget(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
