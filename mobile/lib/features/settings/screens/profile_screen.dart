import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/role_badge.dart';
import '../../auth/providers/auth_provider.dart';
import '../../classes/providers/class_provider.dart';

// Shown when an account-editing action is tapped — backend has no
// update-profile / change-password endpoint yet (auth.service.js).
const _comingSoon = 'Fitur ini akan tersedia segera';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(classProvider.notifier).fetchClasses();
    });
  }

  void _notReady() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(_comingSoon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final classes = ref.watch(classProvider).classes;
    final activeClass = classes.isEmpty ? null : classes.first;
    final role = activeClass?.roleInClass;
    final showRole = role == 'admin_komting' || role == 'bendahara';

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingWidget(message: 'Memuat profil...'),
      );
    }

    final initial = user.name.trim().isEmpty
        ? '?'
        : user.name.trim()[0].toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profil Saya')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
        children: [
          // Centered avatar + name + email + role
          Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.accent,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user.name,
                style: AppTextStyles.h2.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                user.email,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              if (showRole) ...[
                const SizedBox(height: 8),
                RoleBadge.fromApi(role),
              ],
            ],
          ),
          const SizedBox(height: 22),

          // Editable rows (pencil) — wired to "coming soon" until backend ready
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: const Border.fromBorderSide(
                BorderSide(color: AppColors.border, width: 0.5),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Column(
                children: [
                  _ProfileFieldRow(
                    label: 'Nama',
                    value: user.name,
                    onEdit: _notReady,
                  ),
                  const Divider(
                      height: 0.5, thickness: 0.5, color: AppColors.divider),
                  _ProfileFieldRow(
                    label: 'Email',
                    value: user.email,
                    onEdit: _notReady,
                  ),
                  const Divider(
                      height: 0.5, thickness: 0.5, color: AppColors.divider),
                  _ProfileFieldRow(
                    label: 'No. HP',
                    value: user.phone?.isNotEmpty == true
                        ? user.phone!
                        : 'Belum diatur',
                    onEdit: _notReady,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Disabled until backend supports profile update
          Tooltip(
            message: _comingSoon,
            child: const CustomButton(
              label: 'Simpan Perubahan',
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Editable profile field row ─────────────────────────────────

class _ProfileFieldRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;

  const _ProfileFieldRow({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(7),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 13,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
