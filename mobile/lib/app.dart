import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'core/widgets/main_scaffold.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';

class KelaskuApp extends StatelessWidget {
  const KelaskuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KelasKu UINAM',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routerConfig: _router,
    );
  }

  ThemeData _buildTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.card,
      error: AppColors.statusRed,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      dividerColor: AppColors.divider,
      textTheme: AppTextStyles.textTheme,
      primaryTextTheme: AppTextStyles.textTheme,
      iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 22),
      primaryIconTheme: const IconThemeData(color: Colors.white, size: 22),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.1,
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 22),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.body.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/jadwal',
      name: 'jadwal',
      builder: (context, state) => const _PhasePlaceholder(
        tab: MainTab.jadwal,
        phase: 5,
      ),
    ),
    GoRoute(
      path: '/tugas',
      name: 'tugas',
      builder: (context, state) => const _PhasePlaceholder(
        tab: MainTab.tugas,
        phase: 6,
      ),
    ),
    GoRoute(
      path: '/forum',
      name: 'forum',
      builder: (context, state) => const _PhasePlaceholder(
        tab: MainTab.forum,
        phase: 9,
      ),
    ),
    GoRoute(
      path: '/lainnya',
      name: 'lainnya',
      builder: (context, state) => const _PhasePlaceholder(
        tab: MainTab.lainnya,
        phase: 10,
      ),
    ),
  ],
);

class _PhasePlaceholder extends ConsumerWidget {
  final MainTab tab;
  final int phase;

  const _PhasePlaceholder({required this.tab, required this.phase});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainScaffold(
      currentTab: tab,
      appBar: AppBar(
        title: Text(tab.label),
        actions: [
          if (tab == MainTab.lainnya)
            IconButton(
              tooltip: 'Keluar',
              icon: const Icon(Icons.logout),
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.primaryOverlay,
                  shape: BoxShape.circle,
                ),
                child: Icon(tab.icon, size: 32, color: AppColors.primary),
              ),
              const SizedBox(height: 18),
              Text(tab.label, style: AppTextStyles.h2),
              const SizedBox(height: 6),
              Text(
                'Layar ini akan dibuat di Phase $phase.',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
