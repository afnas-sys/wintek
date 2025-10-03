import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/features/auth/presentaion/widgets/custom_snackbar.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/auth/providers/google_auth_notifier.dart';
import 'package:wintek/features/auth/services/google_auth_services.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/features/auth/providers/auth_notifier.dart';
import 'package:wintek/core/router/routes_names.dart';
import 'package:wintek/core/widgets/custom_elevated_button.dart';
import 'package:wintek/features/profile/model/profile_item.dart';
import 'package:wintek/features/profile/provider/profile_provider.dart';
import 'package:wintek/features/profile/screen/responsible_gaming_screen.dart';
import 'package:wintek/features/profile/widgets/profile_tile.dart';
import 'package:wintek/features/auth/domain/model/user_data.dart';
import 'account_screen.dart';
import 'change_password_screen.dart';
import 'terms_conditions_screen.dart';
import 'privacy_policy_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.profilePrimaryColor,
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(
              'Error loading profile: $error',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          data: (userData) {
            return RefreshIndicator(
              onRefresh: () async {
                // ✅ force re-fetch only when user pulls down
                ref.invalidate(profileProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 50),

                    // Profile Card with Avatar
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Card
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(
                            top: 70,
                            bottom: 30,
                          ), // extra top padding
                          decoration: BoxDecoration(
                            color: AppColors.profileSecondaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              // User Info
                              _buildUserInfo(userData),

                              // Divider
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                height: 1,
                                color: AppColors.profileTextcolor.withOpacity(
                                  0.1,
                                ),
                              ),

                              // Profile Options
                              _buildProfileOptions(context, ref, authNotifier),
                            ],
                          ),
                        ),

                        // Profile Avatar (half out of card)
                        Positioned(
                          top: -50, // half outside
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Stack(
                              children: [
                                // Circle Avatar
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.profileTextcolor,
                                      width: 2,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        userData?.profileImage ??
                                            'https://api.builder.io/api/v1/image/assets/TEMP/2d9ca7e1c94e375f00e59a8525e451b4b93eaaa5',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                // Camera Icon
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: AppColors.profileSecondaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(AppImages.cameraIcon),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Logout Button
                    _buildLogoutButton(context, ref, authNotifier),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserProfileData? userData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            userData?.name ?? 'User',
            style: const TextStyle(
              color: AppColors.profileTextcolor,
              fontSize: 20,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userData?.mobileNumber ?? 'USR00000',
                style: const TextStyle(
                  color: AppColors.profileTextcolor,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: userData?.mobileNumber ?? 'USR00000'),
                  );
                  CustomSnackbar.show(
                    backgroundColor: Colors.green,
                    context,
                    message: 'Mobile number copied to clipboard!',
                  );
                },
                child: const Icon(
                  Icons.copy_rounded,
                  color: Colors.white54,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions(
    BuildContext context,
    WidgetRef ref,
    AuthNotifier authNotifier,
  ) {
    final sections = [
      ProfileSection(
        title: 'Account Settings',
        items: [
          ProfileItem(
            'My Account Details',
            Icons.person,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountScreen()),
            ),
          ),
          ProfileItem(
            'Change Password',
            Icons.lock,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              ),
            ),
          ),
        ],
      ),
      ProfileSection(
        title: 'Activity',
        items: [
          ProfileItem(
            'My Game History',
            Icons.games,
            onTap: () => CustomSnackbar.show(
              backgroundColor: Colors.blue,
              context,
              message: 'Game History screen coming soon!',
            ),
          ),
          ProfileItem(
            'Transaction History',
            Icons.receipt,
            onTap: () => Navigator.pushNamed(context, RoutesNames.wallet),
          ),
          ProfileItem(
            'Rewards & Offers Claimed',
            Icons.card_giftcard,
            isSpecial: true,
            onTap: () => CustomSnackbar.show(
              backgroundColor: Colors.blue,
              context,
              message: 'Rewards screen coming soon!',
            ),
          ),
        ],
      ),
      ProfileSection(
        title: 'Preferences',
        items: [
          ProfileItem(
            'Notifications',
            Icons.notifications,
            trailing: _buildToggleSwitch(),
            onTap: () => CustomSnackbar.show(
              backgroundColor: Colors.green,
              context,
              message: 'Notifications toggled!',
            ),
          ),
          ProfileItem(
            'Language',
            Icons.translate,
            trailing: _buildLanguageTrailing(),
            onTap: () => CustomSnackbar.show(
              backgroundColor: Colors.blue,
              context,
              message: 'Language settings coming soon!',
            ),
          ),
        ],
      ),
      ProfileSection(
        title: 'Support',
        items: [
          ProfileItem(
            'Help & FAQ',
            Icons.help,
            onTap: () => CustomSnackbar.show(
              backgroundColor: Colors.blue,
              context,
              message: 'Help & FAQ screen coming soon!',
            ),
          ),
          ProfileItem(
            'Contact Support',
            Icons.support_agent,
            onTap: () => CustomSnackbar.show(
              backgroundColor: Colors.blue,
              context,
              message: 'Contact Support screen coming soon!',
            ),
          ),
          ProfileItem(
            'Report a Problem',
            Icons.report_problem,
            onTap: () => CustomSnackbar.show(
              backgroundColor: Colors.blue,
              context,
              message: 'Report Problem screen coming soon!',
            ),
          ),
        ],
      ),
      ProfileSection(
        title: 'Legal',
        items: [
          ProfileItem(
            'Terms & Conditions',
            Icons.description,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TermsConditionsScreen(),
              ),
            ),
          ),
          ProfileItem(
            'Privacy Policy',
            Icons.privacy_tip,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PrivacyPolicyScreen(),
              ),
            ),
          ),
          ProfileItem(
            'Responsible Gaming',
            Icons.security,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ResponsibleGamingScreen(),
              ),
            ),
          ),
        ],
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections
            .expand(
              (section) => [
                _buildSectionHeader(section.title),
                const SizedBox(height: 20),
                ...section.items.expand(
                  (item) => [
                    _buildOptionTile(
                      item.title,
                      iconContainer: item.isSpecial
                          ? _buildSpecialIconContainer(item.icon)
                          : _buildIconContainer(item.icon),
                      trailing: item.trailing,
                      onTap: item.onTap,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            )
            .toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFFA395EE),
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildOptionTile(
    String title, {
    required Widget iconContainer,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ProfileTile(
      leading: iconContainer,
      title: title,
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0x19A395EE), width: 1),
      ),
      child: Icon(icon, color: Colors.white54, size: 18),
    );
  }

  Widget _buildSpecialIconContainer(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0x19A395EE), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xB22200D4),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white54, size: 18),
    );
  }

  Widget _buildToggleSwitch() {
    return SizedBox(
      height: 20,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        // child: Theme(
        //   data: ThemeData(
        //     splashColor: Colors.transparent,
        //     highlightColor: Colors.transparent,
        //   ),
        // child: Switch(
        //   value: _isNotificationEnabled,
        //   onChanged: (value) =>
        //       setState(() => _isNotificationEnabled = value),
        //   activeColor: const Color(0xFF271777),
        //   activeTrackColor: Colors.white,
        //   inactiveThumbColor: const Color(0xFF271777),
        //   inactiveTrackColor: Colors.white,
        //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // ),
        // ),
      ),
    );
  }

  Widget _buildLanguageTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'English',
          style: TextStyle(
            color: Color(0xFFA395EE),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      ],
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    WidgetRef ref,
    AuthNotifier authNotifier,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showLogoutConfirmation(context, ref, authNotifier),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEB644C),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Icon(Icons.logout_rounded, color: Colors.white, size: 20),
            const Text(
              'Logout',
              style: TextStyle(
                color: AppColors.profileTextcolor,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showLogoutConfirmation(
  BuildContext context,
  WidgetRef ref,
  AuthNotifier authNotifier,
) {
  final googleAuthNotifier = ref.watch(googleAuthProvider.notifier);
  final googleAuthService = GoogleAuthService(ref.read(dioProvider));

  showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF271777),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
          child: Text(
            'Logout',
            style: TextStyle(
              color: AppColors.profileTextcolor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.profileTextcolor, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  backgroundColor: Colors.transparent,
                  borderRadius: 30,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.profileTextcolor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomElevatedButton(
                  backgroundColor: const Color(0xFFEB644C),
                  borderRadius: 30,
                  onPressed: () async {
                    if (googleAuthNotifier.isGoogleLogin) {
                      final res = await googleAuthService.signOut();
                      ref.watch(googleAuthProvider.notifier).setMessage(res);

                      Future.delayed(const Duration(seconds: 2)).then((d) {
                        Navigator.pushNamed(context, RoutesNames.loginScreen);
                        CustomSnackbar.show(
                          backgroundColor: Colors.green,
                          context,
                          message: 'SignOut Successfully',
                        );
                      });

                      log('Google LogOut Success');
                      googleAuthNotifier.isGoogleLogin = false;
                      await ref
                          .read(authNotifierProvider.notifier)
                          .getStorage()
                          .clearCredentials();
                      ref.invalidate(profileProvider);
                    } else {
                      authNotifier.logout(ref);
                      ref.invalidate(profileProvider);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesNames.loginScreen,
                        (_) => false,
                      );
                      CustomSnackbar.show(
                        backgroundColor: Colors.green,
                        context,
                        message: 'SignOut Successfully',
                      );
                      log('Mobile LogOut Success');
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    child: Text(
                      'Yes, Logout',
                      style: TextStyle(
                        color: AppColors.profileTextcolor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
