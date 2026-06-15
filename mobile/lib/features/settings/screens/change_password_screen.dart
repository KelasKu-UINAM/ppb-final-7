import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

// Backend has no change-password endpoint yet (auth.service.js only exposes
// register/login/getProfile), so the form is presentational + disabled save.
const _comingSoon = 'Fitur ini akan tersedia segera';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Ganti Password')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
        children: [
          CustomTextField(
            label: 'Password Lama',
            hint: 'Masukkan password lama',
            controller: _oldCtrl,
            obscureText: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            label: 'Password Baru',
            hint: 'Min. 6 karakter',
            helperText:
                'Minimal 6 karakter, gunakan kombinasi huruf dan angka.',
            controller: _newCtrl,
            obscureText: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            label: 'Konfirmasi Password Baru',
            hint: 'Ulangi password baru',
            controller: _confirmCtrl,
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 22),
          Tooltip(
            message: _comingSoon,
            child: const CustomButton(
              label: 'Simpan Password',
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }
}
