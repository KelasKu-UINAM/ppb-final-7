import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle h1 = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.4,
    height: 1.2,
  );

  static TextStyle h2 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static TextStyle h3 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static TextStyle sectionTitle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );

  static TextStyle label = GoogleFonts.poppins(
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.2,
  );

  static TextStyle buttonLabel = GoogleFonts.poppins(
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static TextStyle bodyLarge = GoogleFonts.nunito(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  static TextStyle body = GoogleFonts.nunito(
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static TextStyle caption = GoogleFonts.nunito(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    letterSpacing: 0.1,
  );

  static TextStyle inputText = GoogleFonts.nunito(
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle inputHint = GoogleFonts.nunito(
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );

  static TextStyle inputError = GoogleFonts.nunito(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.statusRed,
  );

  static TextStyle badgeSmall = GoogleFonts.poppins(
    fontSize: 10.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static TextStyle link = GoogleFonts.nunito(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.none,
  );

  static TextStyle linkMuted = GoogleFonts.nunito(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static TextTheme get textTheme => TextTheme(
        displayLarge: h1,
        headlineLarge: h1,
        headlineMedium: h2,
        headlineSmall: h3,
        titleLarge: h3,
        titleMedium: sectionTitle,
        titleSmall: label,
        bodyLarge: bodyLarge,
        bodyMedium: body,
        bodySmall: bodySmall,
        labelLarge: buttonLabel,
        labelMedium: label,
        labelSmall: caption,
      );
}
