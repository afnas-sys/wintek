import 'package:flutter/material.dart';

class ProfileItem {
  final String title;
  final IconData icon;
  final bool isSpecial;
  final Widget? trailing;
  final VoidCallback? onTap;

  ProfileItem(
    this.title,
    this.icon, {
    this.isSpecial = false,
    this.trailing,
    this.onTap,
  });
}

class ProfileSection {
  final String title;
  final List<ProfileItem> items;

  ProfileSection({required this.title, required this.items});
}
