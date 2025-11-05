import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';

class WithdrawFormFieldWidget extends StatefulWidget {
  const WithdrawFormFieldWidget({super.key});

  @override
  State<WithdrawFormFieldWidget> createState() =>
      _WithdrawFormFieldWidgetState();
}

class _WithdrawFormFieldWidgetState extends State<WithdrawFormFieldWidget> {
  final _upiController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isFormValid = false;

  bool isValidUpiFormat(String upi) {
    // Extensive list of valid UPI handles (as of 2025)
    const validHandles = [
      // 🔹 Popular Apps
      'ybl', 'ibl', 'axl', 'okaxis', 'oksbi', 'okhdfcbank', 'okicici',
      'okyesbank', 'paytm', 'apl', 'upi', 'airtel', 'jio', 'fc', 'ikwik',

      // 🔹 Banks
      'sbi', 'hdfcbank', 'icici', 'axisbank', 'kotak', 'pnb', 'barodampay',
      'barodaupi', 'unionbank', 'indianbank', 'canarabank', 'idfcfirst',
      'yesbank', 'indus', 'uco', 'boi', 'csb', 'aubank', 'dbs', 'rbl',
      'federal', 'karurvysyabank', 'karnatakabank', 'uco', 'uco', 'nsdl',
      'equitas', 'bandhan', 'suryoday', 'dcbbank', 'tmb', 'lvb', 'hdfc',
      'idbi',
      'obc',
      'allahabadbank',
      'vijayabank',
      'andhrabank',
      'corporationbank',

      // 🔹 Payment Banks
      'payzapp', 'freecharge', 'upi', 'nsdlbank', 'fino', 'digibank',
      'esafsmallfinancebank', 'ujjivansmallfinancebank', 'janabanksfb',

      // 🔹 Regional / Co-op Banks
      'karurvysyabank', 'csb', 'saraswat', 'mahanagar', 'pmcbank', 'tjsb',
      'cosmos', 'apmahesh', 'nkgsb', 'rajkotnagrik', 'citizencredit',

      // 🔹 Others (Payment Apps / NBFCs)
      'amazonpay', 'mobikwik', 'phonepe', 'bajaj', 'slice', 'onecard', 'fampay',
    ];

    // Regex for valid UPI ID format
    final regex = RegExp(r'^[\w.\-_]{2,256}@([\w]{2,64})$');
    final match = regex.firstMatch(upi.trim());

    if (match == null) return false;

    final handle = match.group(1)?.toLowerCase();
    return validHandles.contains(handle);
  }

  @override
  void initState() {
    super.initState();
    _upiController.addListener(_validateForm);
    _amountController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          isValidUpiFormat(_upiController.text) &&
          _amountController.text.isNotEmpty;
    });
  }

  void _handleWithdraw() {
    Flushbar(
      // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: AppColors.paymentNinthColor,
      duration: const Duration(seconds: 3),
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Withdrawal Request Submitted',
            style: Theme.of(context).textTheme.paymentBodySmallPrimary,
          ),
          const SizedBox(height: 6),
          Text(
            '₹${_amountController.text} withdrawal is under review. It may take up to 24 hours.',
            style: Theme.of(context).textTheme.paymentBodySmallPrimary,
          ),
        ],
      ),
    ).show(context);
    _upiController.clear();
    _amountController.clear();
  }

  @override
  void dispose() {
    _upiController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'UPI ID',
            style: Theme.of(context).textTheme.paymentSmallPrimary,
          ),
          const SizedBox(height: 10),
          _buildUpiField(),
          const SizedBox(height: 30),
          Text(
            'Withdraw Amount',
            style: Theme.of(context).textTheme.paymentSmallPrimary,
          ),
          const SizedBox(height: 10),
          _buildAmountField(),
          const SizedBox(height: 30),
          _buildWithdrawButton(),
        ],
      ),
    );
  }

  Widget _buildUpiField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.paymentThirdColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(AppImages.upiIcon)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: _upiController,
              style: Theme.of(context).textTheme.paymentSmallSecondary,
              decoration: InputDecoration(
                hintText: 'Enter UPI ID',
                hintStyle: Theme.of(context).textTheme.paymentSmallThird,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (isValidUpiFormat(_upiController.text))
            const Icon(
              Icons.check_circle,
              color: AppColors.paymentFifthColor,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.paymentThirdColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          Text('₹', style: Theme.of(context).textTheme.paymentBodyLargePrimary),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.paymentSmallSecondary,
              decoration: InputDecoration(
                hintText: 'Enter Amount',
                hintStyle: Theme.of(context).textTheme.paymentSmallThird,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isFormValid ? _handleWithdraw : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid
              ? AppColors.paymentSixthColor
              : AppColors.paymentSeventhColor,
          disabledBackgroundColor: AppColors.paymentSeventhColor,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Text(
          'Withdraw Now',
          style: Theme.of(context).textTheme.paymentBodyLargeSecondary,
        ),
      ),
    );
  }
}
