import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/constants/app_strings.dart';
import '../../../config/constants/app_images.dart';
import '../../../config/constants/ui_constants.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedLogo(isDark),
            const SizedBox(height: UIConstants.paddingMD),
            _buildSubtitle(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(bool isDark) {
    return SizedBox(
      width: UIConstants.splashLogoWidth,
      child: Image.asset(
        isDark ? AppImages.splashLogoDark : AppImages.splashLogoLight,
      ),
    )
        .animate()
        .scale(
          duration: Duration(milliseconds: UIConstants.animSlow),
          curve: Curves.elasticOut,
        )
        .then()
        .shake(
          duration: Duration(milliseconds: UIConstants.animFast),
          hz: 4,
          curve: Curves.easeInOut,
        )
        .then()
        .shimmer(
          duration: Duration(milliseconds: UIConstants.animShimmer),
          color: Colors.white.withOpacity(0.5),
        );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      AppStrings.fitness,
      style: AppTextStyles.h4.copyWith(
        fontSize: 16,
        letterSpacing: 1,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        fontWeight: FontWeight.w500,
      ),
    )
        .animate()
        .fadeIn(
          duration: Duration(milliseconds: UIConstants.animMedium),
          delay: Duration(milliseconds: UIConstants.animSlow),
        )
        .slideY(
          begin: 0.3,
          end: 0,
          duration: Duration(milliseconds: UIConstants.animMedium),
          delay: Duration(milliseconds: UIConstants.animSlow),
          curve: Curves.easeOut,
        );
  }
}
