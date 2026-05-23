import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

enum UserRole { adminKomting, bendahara, mahasiswa }

extension UserRoleX on UserRole {
  static UserRole fromString(String? value) {
    switch (value) {
      case 'admin_komting':
        return UserRole.adminKomting;
      case 'bendahara':
        return UserRole.bendahara;
      default:
        return UserRole.mahasiswa;
    }
  }

  String get apiValue {
    switch (this) {
      case UserRole.adminKomting:
        return 'admin_komting';
      case UserRole.bendahara:
        return 'bendahara';
      case UserRole.mahasiswa:
        return 'mahasiswa';
    }
  }

  String get displayLabel {
    switch (this) {
      case UserRole.adminKomting:
        return 'Komting';
      case UserRole.bendahara:
        return 'Bendahara';
      case UserRole.mahasiswa:
        return 'Mahasiswa';
    }
  }
}

class RoleBadge extends StatelessWidget {
  final UserRole role;
  final bool compact;

  const RoleBadge({
    super.key,
    required this.role,
    this.compact = false,
  });

  factory RoleBadge.fromApi(String? roleString, {bool compact = false}) {
    return RoleBadge(role: UserRoleX.fromString(roleString), compact: compact);
  }

  ({Color background, Color foreground, IconData icon}) get _style {
    switch (role) {
      case UserRole.adminKomting:
        return (
          background: AppColors.accentSoft,
          foreground: AppColors.accentDark,
          icon: Icons.workspace_premium,
        );
      case UserRole.bendahara:
        return (
          background: AppColors.primaryOverlay,
          foreground: AppColors.primary,
          icon: Icons.account_balance_wallet,
        );
      case UserRole.mahasiswa:
        return (
          background: AppColors.border,
          foreground: AppColors.textMuted,
          icon: Icons.school,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final padding = compact
        ? const EdgeInsets.symmetric(horizontal: 7, vertical: 2)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 4);
    final fontSize = compact ? 10.0 : 11.0;
    final iconSize = compact ? 11.0 : 13.0;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: iconSize, color: style.foreground),
          const SizedBox(width: 4),
          Text(
            role.displayLabel,
            style: AppTextStyles.badgeSmall.copyWith(
              color: style.foreground,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
