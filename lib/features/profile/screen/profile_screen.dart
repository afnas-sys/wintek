import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wintek/features/auth/domain/constants/auth_api_constants.dart';
import 'package:wintek/features/auth/presentaion/widgets/custom_snackbar.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/auth/providers/google_auth_notifier.dart';
import 'package:wintek/features/auth/services/google_auth_services.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/features/auth/providers/auth_notifier.dart';
import 'package:wintek/core/router/routes_names.dart';
import 'package:wintek/features/profile/model/profile_item.dart';
import 'package:wintek/features/profile/provider/profile_provider.dart';
import 'package:wintek/features/profile/screen/contact_support_screen.dart';
import 'package:wintek/features/profile/screen/responsible_gaming_screen.dart';
import 'package:wintek/features/profile/widgets/profile_tile.dart';
import 'package:wintek/features/auth/domain/model/user_data.dart';
import 'account_screen.dart';
import 'change_password_screen.dart';
import 'terms_conditions_screen.dart';
import 'privacy_policy_screen.dart';
import 'help_faq_screen.dart';
import 'report_problem_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String selectedLanguage = 'English';
  bool _isNotificationEnabled = true;

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
          ),
          ProfileItem(
            'Language',
            Icons.translate,
            trailing: _buildLanguageTrailing(),
            onTap: () => _showLanguageBottomSheet(context),
          ),
        ],
      ),
      ProfileSection(
        title: 'Support',
        items: [
          ProfileItem(
            'Help & FAQ',
            Icons.help,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpFaqScreen()),
            ),
          ),
          ProfileItem(
            'Contact Support',
            Icons.support_agent,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContactSupportScreen(),
              ),
            ),
          ),
          ProfileItem(
            'Report a Problem',
            Icons.report_problem,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReportProblemScreen(),
              ),
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
    return Transform.scale(
      scale: 0.6,
      child: Switch(
        value: _isNotificationEnabled,
        onChanged: (bool value) {
          setState(() {
            _isNotificationEnabled = value;
          });
        },
        activeTrackColor: Colors.white,
        activeThumbColor: AppColors.profileSecondaryColor,
        inactiveThumbColor: AppColors.profileSecondaryColor,
        inactiveTrackColor: Colors.grey.shade300,
      ),
    );
  }

  Widget _buildLanguageTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          selectedLanguage,
          style: const TextStyle(
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

  void _showLanguageBottomSheet(BuildContext context) {
    String tempSelectedLanguage = selectedLanguage;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => StatefulBuilder(
        builder: (context, setBottomSheetState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF271777),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.075,
              ),
              child: Column(
                children: [
                  // Header with title and save button
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Choose Language',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.375,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedLanguage = tempSelectedLanguage;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFA82E),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Color(0xFF0B0F1A),
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Language options
                  Expanded(
                    child: Column(
                      children: [
                        _buildLanguageOption(
                          'English',
                          tempSelectedLanguage == 'English',
                          (value) {
                            if (value == true) {
                              setBottomSheetState(() {
                                tempSelectedLanguage = 'English';
                              });
                            }
                          },
                        ),
                        _buildDivider(),
                        _buildLanguageOption(
                          'Hindi',
                          tempSelectedLanguage == 'Hindi',
                          (value) {
                            if (value == true) {
                              setBottomSheetState(() {
                                tempSelectedLanguage = 'Hindi';
                              });
                            }
                          },
                        ),
                        _buildDivider(),
                        _buildLanguageOption(
                          'Marathi',
                          tempSelectedLanguage == 'Marathi',
                          (value) {
                            if (value == true) {
                              setBottomSheetState(() {
                                tempSelectedLanguage = 'Marathi';
                              });
                            }
                          },
                        ),
                        _buildDivider(),
                        _buildLanguageOption(
                          'Tamil',
                          tempSelectedLanguage == 'Tamil',
                          (value) {
                            if (value == true) {
                              setBottomSheetState(() {
                                tempSelectedLanguage = 'Tamil';
                              });
                            }
                          },
                        ),
                        _buildDivider(),
                        _buildLanguageOption(
                          'Bengali',
                          tempSelectedLanguage == 'Bengali',
                          (value) {
                            if (value == true) {
                              setBottomSheetState(() {
                                tempSelectedLanguage = 'Bengali';
                              });
                            }
                          },
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

  Widget _buildLanguageOption(
    String language,
    bool isSelected,
    ValueChanged<bool?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(!isSelected),
              child: Text(
                language,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 1,
      color: const Color(0xFFE5E5E5).withOpacity(0.1),
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
  final googleAuthService = GoogleAuthService(ref.read(dioProvider));

  showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 388, minWidth: 300),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const Text(
                  'Logout',
                  style: TextStyle(
                    color: Color(0xFF010101),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 14),

                // Subtitle
                Container(
                  constraints: const BoxConstraints(maxWidth: 266),
                  child: const Text(
                    'Are you sure you want to logout?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(1, 1, 1, 0.5),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.43, // line-height: 20px / font-size: 14px
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Buttons Row
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color.fromRGBO(0, 0, 0, 0.5),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF242424),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height:
                                  1.43, // line-height: 20px / font-size: 14px
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Logout Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final isGoogleLogin =
                              prefs.getBool(AuthApiConstants.isGoogleLogin) ??
                              false;
                          log('shre pref data is : $isGoogleLogin');
                          if (isGoogleLogin) {
                            final res = await googleAuthService.signOut();

                            if (!context.mounted) return;

                            ref
                                .watch(googleAuthProvider.notifier)
                                .setMessage(res);

                            Future.delayed(const Duration(seconds: 2)).then((
                              d,
                            ) {
                              if (context.mounted) {
                                Navigator.pushNamed(
                                  context,
                                  RoutesNames.loginScreen,
                                );
                                CustomSnackbar.show(
                                  backgroundColor: Colors.green,
                                  context,
                                  message: 'SignOut Successfully',
                                );
                              }
                            });

                            log('Google LogOut Success');
                            prefs.clear();
                            await ref
                                .read(authNotifierProvider.notifier)
                                .getStorage()
                                .clearCredentials();

                            if (context.mounted) {
                              ref.invalidate(profileProvider);
                            }
                          } else {
                            authNotifier.logout(ref);

                            if (!context.mounted) return;

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
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xFFEB644C),
                          ),
                          child: const Text(
                            'Yes, Logout',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height:
                                  1.43, // line-height: 20px / font-size: 14px
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Support')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SectionTitle(title: 'Customer Support'),
            InfoTile(label: 'Contact Number', value: '+91 98765 43210'),
            InfoTile(label: 'Email Address', value: '+91 98765 43210'),

            const SizedBox(height: 24),
            const SectionTitle(title: 'Social Media'),
            InfoTile(label: 'Instagram', value: '@pixelsurfer'),
            InfoTile(label: 'Twitter', value: '@pixelsurfer'),
            InfoTile(label: 'Facebook', value: '@pixelsurfer'),

            const SizedBox(height: 24),
            const SectionTitle(title: 'Live Chat & Call'),
            ElevatedButton(
              onPressed: () {
                // Add live chat functionality here
              },
              child: const Text('Start Live Chat'),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'All Conversations are safe & private.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const InfoTile({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
