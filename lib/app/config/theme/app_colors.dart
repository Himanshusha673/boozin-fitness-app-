import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color orange = Color(0xFFFF6B35);
  static const Color darkOrange = Color(0xFFE55A28);

  // Light Theme Colors
  static const Color primaryLight = orange;
  static const Color accentLight = Color(0xFFFFB800);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF0F0F0);
  static const Color textPrimaryLight = Color(0xFF212529);
  static const Color textSecondaryLight = Color(0xFF6C757D);
  static const Color dividerLight = Color(0xFFE9ECEF);

  static const Color sliderOffColor = Color(0xFFC4C4C4);

  // Dark Theme Colors
  static const Color primaryDark = orange;

  static const Color accentDark = Color(0xFFFFB800);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFC4C4C4);
  static const Color dividerDark = Color(0xFF343A40);

  // Common Colors
  static const Color error = Color(0xFFDC3545);
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);

  // Gradient Colors
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [orange, darkOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get cardGradientLight => LinearGradient(
        colors: [
          surfaceLight,
          surfaceLight.withOpacity(0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get cardGradientDark => LinearGradient(
        colors: [
          surfaceDark,
          surfaceDark.withOpacity(0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
