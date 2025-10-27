import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ProfileTile({
    super.key,
    this.leading,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            if (leading != null) leading!,
            if (leading != null) const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (trailing != null) const SizedBox(width: 16),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
