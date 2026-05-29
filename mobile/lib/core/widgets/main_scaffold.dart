import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

enum MainTab { beranda, jadwal, tugas, forum, lainnya }

extension MainTabX on MainTab {
  String get label {
    switch (this) {
      case MainTab.beranda:
        return 'Beranda';
      case MainTab.jadwal:
        return 'Jadwal';
      case MainTab.tugas:
        return 'Tugas';
      case MainTab.forum:
        return 'Forum';
      case MainTab.lainnya:
        return 'Lainnya';
    }
  }

  IconData get icon {
    switch (this) {
      case MainTab.beranda:
        return Icons.home_outlined;
      case MainTab.jadwal:
        return Icons.calendar_today_outlined;
      case MainTab.tugas:
        return Icons.assignment_outlined;
      case MainTab.forum:
        return Icons.chat_bubble_outline;
      case MainTab.lainnya:
        return Icons.more_horiz;
    }
  }

  String get route {
    switch (this) {
      case MainTab.beranda:
        return '/home';
      case MainTab.jadwal:
        return '/jadwal';
      case MainTab.tugas:
        return '/tugas';
      case MainTab.forum:
        return '/forum';
      case MainTab.lainnya:
        return '/lainnya';
    }
  }
}

/// Shell widget untuk StatefulShellRoute — satu instance persistent
/// selama sesi. IndexedStack dikelola oleh [StatefulNavigationShell]
/// sehingga tidak ada GlobalKey conflict dan setiap tab branch
/// state-nya tetap hidup saat tab di-switch.
class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: _BottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          // Tap tab aktif → kembali ke initial route branch tersebut
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 4),
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(
              MainTab.values.length,
              (i) => Expanded(
                child: _NavItem(
                  tab: MainTab.values[i],
                  active: i == currentIndex,
                  onTap: () => onTap(i),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final MainTab tab;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textMuted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tab.icon, size: 22, color: color),
              const SizedBox(height: 3),
              Text(
                tab.label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 10.5,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                height: 2,
                width: active ? 20 : 0,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
