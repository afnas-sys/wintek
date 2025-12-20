import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/theme/theme.dart';
import 'package:wintek/core/utils/sound_manager.dart';
import 'package:wintek/features/game/crash/providers/crash_music_provider.dart';

/// Shows a settings drawer positioned below a specific widget (like a hamburger icon)
void showCrashSettingsDrawer({
  required BuildContext context,
  required Offset position,
  required Size size,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Settings',
    barrierColor: AppColors.crashSixtySixthColor,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      // Calculate position: right below the icon
      final top = position.dy + size.height;
      final right =
          MediaQuery.of(context).size.width - position.dx - size.width;

      return Stack(
        children: [
          Positioned(
            top: top,
            right: right,
            child: Material(
              color: AppColors.crashTwentyFirstColor,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: AppColors.crashThirteenthColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const _SettingsDrawerContent(),
              ),
            ),
          ),
        ],
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );
    },
  );
}

/// The content of the settings drawer
class _SettingsDrawerContent extends StatelessWidget {
  const _SettingsDrawerContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Settings',
                style: Theme.of(context).textTheme.crashBodyTitleSmallThird,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.close,
                  color: AppColors.crashPrimaryColor,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(color: AppColors.crashThirdColor, height: 16),
          // Music and Start Sound Toggles
          Consumer(
            builder: (context, ref, child) {
              final isMusicOn = ref.watch(crashMusicProvider);
              final isStartSoundOn = ref.watch(crashStartSoundProvider);

              return Column(
                children: [
                  // Music Toggle
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        const Icon(
                          Icons.music_note,
                          color: AppColors.crashPrimaryColor,
                          size: 14,
                        ),
                        Text(
                          'Music',
                          style: Theme.of(
                            context,
                          ).textTheme.crashBodyMediumPrimary,
                        ),
                      ],
                    ),
                    trailing: Transform.scale(
                      scale: 0.6,
                      child: Switch(
                        inactiveTrackColor: AppColors.crashThirteenthColor,
                        inactiveThumbColor: AppColors.crashTwentyNinethColor,
                        activeTrackColor: AppColors.crashThirteenthColor,
                        value: isMusicOn,
                        onChanged: (value) async {
                          ref.read(crashMusicProvider.notifier).setMusic(value);
                          if (value) {
                            await SoundManager.crashMusic();
                          } else {
                            await SoundManager.stopCrashMusic();
                          }
                        },
                      ),
                    ),
                  ),
                  const Divider(color: AppColors.crashThirdColor, height: 16),
                  // Sound Effects Toggle (controls start sound and flew away sound)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        const Icon(
                          Icons.volume_up,
                          color: AppColors.crashPrimaryColor,
                          size: 14,
                        ),
                        Text(
                          'Sound',
                          style: Theme.of(
                            context,
                          ).textTheme.crashBodyMediumPrimary,
                        ),
                      ],
                    ),
                    trailing: Transform.scale(
                      scale: 0.6,
                      child: Switch(
                        inactiveTrackColor: AppColors.crashThirteenthColor,
                        inactiveThumbColor: AppColors.crashTwentyNinethColor,
                        activeTrackColor: AppColors.crashThirteenthColor,
                        value: isStartSoundOn,
                        onChanged: (value) {
                          ref
                              .read(crashStartSoundProvider.notifier)
                              .setStartSound(value);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
