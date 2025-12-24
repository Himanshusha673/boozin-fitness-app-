import 'package:boozin_fitness/app/utils/app_utils.dart';
import 'package:boozin_fitness/app/utils/ui_utils.dart';
import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../config/constants/ui_constants.dart';
import '../../../config/constants/app_strings.dart';

class HealthCard extends StatelessWidget {
  final String title;
  final num value;
  final String goal;
  final double progress;
  final String image;
  final bool isDark;

  const HealthCard({
    super.key,
    required this.title,
    required this.value,
    required this.goal,
    required this.progress,
    required this.image,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = UIUtils.clampProgress(progress);

    return Container(
      padding: const EdgeInsets.all(UIConstants.paddingLG),
      decoration: UIUtils.cardDecoration(isDark),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleRow(),
                const SizedBox(height: UIConstants.paddingXL),
                _buildProgressBar(clampedProgress),
                const SizedBox(height: UIConstants.paddingSM),
                _buildFooter(clampedProgress),
              ],
            ),
          ),
          const SizedBox(width: UIConstants.paddingXL),
          _buildImage(isDark),
        ],
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        Text(
          '$title:',
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.normal),
        ),
        const SizedBox(width: UIConstants.paddingSM),
        Text(
          AppUtils.formatWithComma(value),
          style: AppTextStyles.h3.copyWith(
              fontSize: 21, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double progress) {
    return Stack(
      children: [
        Container(
          height: UIConstants.progressBarHeight,
          decoration: BoxDecoration(
            color: isDark ? AppColors.dividerDark : AppColors.sliderOffColor,
            borderRadius: BorderRadius.circular(UIConstants.radiusMD),
          ),
        ),
        FractionallySizedBox(
          widthFactor: progress,
          child: Container(
            height: UIConstants.progressBarHeight,
            decoration: BoxDecoration(
              color: UIUtils.progressColor(isDark),
              borderRadius: BorderRadius.circular(UIConstants.radiusMD),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(double progress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '0',
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
        ),
        if (progress >= 1.0) _goalReachedBadge(),
        Text(
          '${AppStrings.goalPrefix}$goal',
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _goalReachedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.paddingSM,
        vertical: UIConstants.paddingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.2),
        borderRadius: BorderRadius.circular(UIConstants.radiusSM),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.check_circle,
            size: UIConstants.iconSize,
            color: AppColors.success,
          ),
          SizedBox(width: UIConstants.paddingXS),
          Text(
            AppStrings.goalReached,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildImage(bool isDark) {
    return SizedBox(
      width: UIConstants.imageSize,
      height: UIConstants.imageSize,
      child: Image.asset(
        image,
        color: isDark ? AppColors.surfaceLight : AppColors.surfaceDark,
      ),
    );
  }
}
