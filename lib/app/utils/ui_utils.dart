import 'package:boozin_fitness/app/config/constants/ui_constants.dart';
import 'package:boozin_fitness/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';


class UIUtils {
  static double clampProgress(double value) {
    return value.clamp(0.0, 1.0);
  }

  static BoxDecoration cardDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(UIConstants.radiusLG),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.black.withOpacity(0.05),
          blurRadius: UIConstants.shadowBlur,
          offset: UIConstants.shadowOffset,
        ),
      ],
    );
  }

  static Color progressColor(bool isDark) {
    return isDark
        ? AppColors.backgroundLight
        : AppColors.backgroundDark;
  }
}
