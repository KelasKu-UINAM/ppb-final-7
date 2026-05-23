import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

enum StatusBadgeType { success, warning, danger, info, neutral }

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;
  final IconData? icon;
  final EdgeInsetsGeometry padding;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  });

  const StatusBadge.lunas({super.key, this.icon = Icons.check_circle})
      : label = 'Lunas',
        type = StatusBadgeType.success,
        padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3);

  const StatusBadge.belum({super.key, this.icon = Icons.cancel})
      : label = 'Belum',
        type = StatusBadgeType.danger,
        padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3);

  const StatusBadge.aman({super.key, this.icon})
      : label = 'Aman',
        type = StatusBadgeType.success,
        padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3);

  const StatusBadge.mendekat({super.key, this.icon = Icons.schedule})
      : label = 'Mendekat',
        type = StatusBadgeType.warning,
        padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3);

  const StatusBadge.lewat({super.key, this.icon = Icons.warning_rounded})
      : label = 'Lewat',
        type = StatusBadgeType.danger,
        padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3);

  ({Color background, Color foreground}) get _palette {
    switch (type) {
      case StatusBadgeType.success:
        return (background: AppColors.statusGreenBg, foreground: AppColors.statusGreen);
      case StatusBadgeType.warning:
        return (background: AppColors.statusAmberBg, foreground: AppColors.statusAmber);
      case StatusBadgeType.danger:
        return (background: AppColors.statusRedBg, foreground: AppColors.statusRed);
      case StatusBadgeType.info:
        return (background: AppColors.primaryOverlay, foreground: AppColors.primary);
      case StatusBadgeType.neutral:
        return (background: AppColors.border, foreground: AppColors.textMuted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _palette;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: palette.foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.badgeSmall.copyWith(color: palette.foreground),
          ),
        ],
      ),
    );
  }
}
