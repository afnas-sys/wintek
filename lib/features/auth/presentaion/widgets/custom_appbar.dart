import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wintek/core/constants/app_colors.dart';
import 'package:wintek/core/constants/app_images.dart';
import 'package:wintek/core/theme/theme.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final double height;
  final bool showBackButton; // optional back button

  const CustomAppbar({
    super.key,
    required this.title,
    required this.subtitle,
    this.height = 270,
    this.showBackButton = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgAppbarAuthScreen,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.bgAppbarAuthScreen,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Back Button | Center Logo | Placeholder
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                child: Row(
                  children: [
                    // Left side: back button or empty space
                    if (showBackButton)
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(FontAwesomeIcons.angleLeft),
                      )
                    else
                      const SizedBox(width: 48), // keeps layout balance
                    // Center: Logo
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          AppImages.appbarImage,
                          height: 26,
                          width: 128,
                        ),
                      ),
                    ),

                    // Right side: same width as back button for symmetry
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Title + Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      //!BODY LARGE
                      // style: Theme.of(context).textTheme.bodyLarge,
                      style: Theme.of(context).textTheme.authHeadlineMedium,
                    ),
                    const SizedBox(height: 10),
                    //!BODY MEDIUM
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.authBodyLargePrimary,
                      // style: Theme.of(context).textTheme.bodyMedium,
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
