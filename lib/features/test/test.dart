// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:wintek/features/game/aviator/providers/user_provider.dart';

// class Test extends ConsumerStatefulWidget {
//   const Test({super.key});

//   @override
//   ConsumerState<Test> createState() => _TestState();
// }

// class _TestState extends ConsumerState<Test> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch user data on init
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(userProvider.notifier).fetchUser();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userAsync = ref.watch(userProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text('User Data')),
//       body: userAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(child: Text('Error: $error')),
//         data: (userModel) {
//           if (userModel == null) {
//             return const Center(child: Text('No data available'));
//           }
//           final user = userModel.data;
//           return SingleChildScrollView(
//             child: Card(
//               margin: const EdgeInsets.all(16.0),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Status: ${userModel.status}'),
//                     const SizedBox(height: 16),
//                     Text('ID: ${user.id}'),
//                     Text('User Name: ${user.userName}'),
//                     Text('Mobile: ${user.mobile}'),
//                     Text('Wallet: ${user.wallet}'),
//                     Text('Verified: ${user.verified}'),
//                     Text('OTP Verified: ${user.otpVerified}'),
//                     Text('Status: ${user.status}'),
//                     Text('Is Show: ${user.isShow}'),
//                     Text('Picture: ${user.picture}'),
//                     Text('Branch Name: ${user.branchName}'),
//                     Text('Bank Name: ${user.bankName}'),
//                     Text('Account Holder Name: ${user.accountHolderName}'),
//                     Text('Account No: ${user.accountNo}'),
//                     Text('IFSC Code: ${user.ifscCode}'),
//                     Text('Referral Code: ${user.referralCode}'),
//                     Text('UPI ID: ${user.upiId}'),
//                     Text('UPI Number: ${user.upiNumber}'),
//                     Text('Betting: ${user.betting}'),
//                     Text('Transfer: ${user.transfer}'),
//                     Text('FCM: ${user.fcm}'),
//                     Text('Personal Notification: ${user.personalNotification}'),
//                     Text('Main Notification: ${user.mainNotification}'),
//                     Text('Starline Notification: ${user.starlineNotification}'),
//                     Text(
//                       'Galidisawar Notification: ${user.galidisawarNotification}',
//                     ),
//                     if (user.transactionBlockedUntil != null)
//                       Text(
//                         'Transaction Blocked Until: ${user.transactionBlockedUntil}',
//                       ),
//                     Text(
//                       'Transaction Permanently Blocked: ${user.transactionPermanentlyBlocked}',
//                     ),
//                     Text('Created At: ${user.createdAt}'),
//                     Text('Updated At: ${user.updatedAt}'),
//                     Text('Authentication: ${user.authentication}'),
//                     Text('Last Login: ${user.lastLogin}'),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:wintek/features/game/crash/widgets/custom_slider.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CustomSlider()],
        ),
      ),
    );
  }
}
