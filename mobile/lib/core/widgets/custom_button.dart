import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

enum CustomButtonVariant { primary, secondary, danger, ghost, whatsapp }

enum CustomButtonSize { regular, compact }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final CustomButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.size = CustomButtonSize.regular,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  bool get _enabled => onPressed != null && !isLoading;

  Color get _backgroundColor {
    switch (variant) {
      case CustomButtonVariant.primary:
        return AppColors.primary;
      case CustomButtonVariant.secondary:
        return AppColors.card;
      case CustomButtonVariant.danger:
        return AppColors.dangerBg;
      case CustomButtonVariant.ghost:
        return Colors.transparent;
      case CustomButtonVariant.whatsapp:
        return AppColors.whatsapp;
    }
  }

  Color get _foregroundColor {
    switch (variant) {
      case CustomButtonVariant.primary:
      case CustomButtonVariant.whatsapp:
        return Colors.white;
      case CustomButtonVariant.secondary:
        return AppColors.primary;
      case CustomButtonVariant.danger:
        return AppColors.dangerText;
      case CustomButtonVariant.ghost:
        return AppColors.textPrimary;
    }
  }

  BorderSide get _borderSide {
    switch (variant) {
      case CustomButtonVariant.secondary:
        return const BorderSide(color: AppColors.primary, width: 1);
      case CustomButtonVariant.danger:
        return const BorderSide(color: AppColors.dangerText, width: 1);
      default:
        return BorderSide.none;
    }
  }

  double get _height => size == CustomButtonSize.compact ? 40 : 50;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyles.buttonLabel.copyWith(
      color: _foregroundColor,
      fontSize: size == CustomButtonSize.compact ? 13 : 14.5,
    );

    final child = isLoading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation<Color>(_foregroundColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: size == CustomButtonSize.compact ? 16 : 18),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final button = Material(
      color: _enabled ? _backgroundColor : _backgroundColor.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: _height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.fromBorderSide(_borderSide),
          ),
          alignment: Alignment.center,
          child: IconTheme(
            data: IconThemeData(color: _foregroundColor, size: 18),
            child: child,
          ),
        ),
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
