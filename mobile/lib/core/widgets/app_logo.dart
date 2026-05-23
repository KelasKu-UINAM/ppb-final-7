import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class KelasKuLogo extends StatelessWidget {
  final double size;

  const KelasKuLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.menu_book_rounded,
        size: size * 0.5,
        color: Colors.white,
      ),
    );
  }
}

class AppHeader extends StatelessWidget {
  final bool compact;

  const AppHeader({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final logoSize = compact ? 60.0 : 80.0;
    final titleSize = compact ? 19.0 : 22.0;
    final subtitleSize = compact ? 11.5 : 12.5;
    final padding = compact
        ? const EdgeInsets.fromLTRB(24, 28, 24, 20)
        : const EdgeInsets.fromLTRB(24, 44, 24, 36);
    final gap = compact ? 10.0 : 14.0;

    return Padding(
      padding: padding,
      child: Column(
        children: [
          KelasKuLogo(size: logoSize),
          SizedBox(height: gap),
          Text(
            'KelasKu UINAM',
            style: AppTextStyles.h1.copyWith(
              fontSize: titleSize,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'UIN Alauddin Makassar',
            style: AppTextStyles.caption.copyWith(
              fontSize: subtitleSize,
              color: AppColors.textHint,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
