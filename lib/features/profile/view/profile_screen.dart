import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/presentaion/widgets/custom_snackbar.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/auth/providers/google_auth_notifier.dart';
import 'package:wintek/features/auth/services/google_auth_services.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/features/auth/providers/auth_notifier.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/router/routes_names.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 72, 54, 161),
              ),
              child: Column(
                children: [
                  Transform.translate(
                    offset: const Offset(0, -35),
                    child: Container(
                      padding: const EdgeInsets.all(2), // border thickness
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // border color
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AppImages.homeSpinToWinImage,
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                  ),
                  const Text('Rahul Sharma'),
                  Text(
                    'Rahul Sharma',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Divider(color: Colors.grey),
                  // ✅ Scrollable list of 16 items
                  ListView.builder(
                    itemCount: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return const ListTile(
                        leading: Icon(Icons.person),
                        title: Text('My Account Details'),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              width: double.infinity,
              textColor: Colors.white,
              borderRadius: 30,
              backgroundColor: const Color(0XFFEB644C),

              onPressed: () {
                _showLogoutConfirmation(context, ref, authNotifier);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.logout, height: 24, width: 24),
                  const SizedBox(width: 10),
                  const Text('Logout'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showLogoutConfirmation(
  BuildContext context,
  WidgetRef ref,
  AuthNotifier authNotifier,
) async {
  final googleAuthNotifier = ref.watch(googleAuthProvider.notifier);
  final googleAuthService = GoogleAuthService(ref.read(dioProvider));
  showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(child: const Text('Logout')),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          CustomElevatedButton(
            backgroundColor: Colors.transparent,
            borderRadius: 30,
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.authBodyMediumFourth,
              ),
            ),
          ),

          CustomElevatedButton(
            backgroundColor: Color(0XFFEB644C),
            borderRadius: 30,
            onPressed: () async {
              if (googleAuthNotifier.isGoogleLogin) {
                final res = await googleAuthService.signOut();
                ref.watch(googleAuthProvider.notifier).setMessage(res);

                Future.delayed(Duration(seconds: 2)).then((d) {
                  Navigator.pushNamed(context, RoutesNames.loginScreen);
                  CustomSnackbar.show(
                    backgroundColor: AppColors.snackbarSuccessValidateColor,
                    context,
                    message: 'SignOut Successfully',
                  );
                });

                log('Google LogOUt Sucess');
                googleAuthNotifier.isGoogleLogin = false;
                await ref
                    .read(authNotifierProvider.notifier)
                    .getStorage()
                    .clearCredentials();
              } else {
                authNotifier.logout(ref);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesNames.loginScreen,
                  (_) => false,
                );
                CustomSnackbar.show(
                  backgroundColor: AppColors.snackbarSuccessValidateColor,
                  context,
                  message: 'SignOut Successfully',
                );
                log('Mobile LogOUt Sucess');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Text(
                'Yes, Logout',
                style: Theme.of(context).textTheme.authBodyMediumThird,
              ),
            ),
          ),
        ],
      );
    },
  );
}
