import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:boozin_fitness/app/utils/app_utils.dart';

import '../../../config/constants/ui_constants.dart';
import '../../../config/constants/app_strings.dart';
import '../../../config/constants/app_images.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';
import '../widgets/health_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Obx(() => _buildBody(context, isDark)),
    );
  }

  Widget _buildBody(BuildContext context, bool isDark) {
    if (controller.isLoading.value) {
      return _buildLoadingScreen(context);
    }

    // if (controller.needsPermission && !controller.hasData) {
    //   return _buildPermissionDeniedScreen(context, isDark);
    // }

    return _buildHealthDataScreen(context, isDark);
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  // Widget _buildPermissionDeniedScreen(BuildContext context, bool isDark) {
  //   return SafeArea(
  //     child: Padding(
  //       padding: const EdgeInsets.all(UIConstants.paddingXL),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _buildHeader(context),
  //           const SizedBox(height: UIConstants.paddingXL * 2),
  //           Expanded(
  //             child: Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     Icons.privacy_tip,
  //                     size: 80,
  //                     color: Theme.of(context)
  //                         .colorScheme
  //                         .onSurface
  //                         .withOpacity(0.6),
  //                   ),
  //                   const SizedBox(height: UIConstants.paddingXL),
  //                   Text(
  //                     AppStrings.permissionsRequired,
  //                     style: AppTextStyles.h2.copyWith(
  //                       color: Theme.of(context).colorScheme.onSurface,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   const SizedBox(height: UIConstants.paddingMD),
  //                   Text(
  //                     controller.permissionMessage,
  //                     style: AppTextStyles.bodyMedium.copyWith(
  //                       color: Theme.of(context)
  //                           .colorScheme
  //                           .onSurface
  //                           .withOpacity(0.7),
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   const SizedBox(height: UIConstants.paddingXL),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       controller.showPermissionDialogManually();
  //                     },
  //                     child: const Text(AppStrings.grantPermissions),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildHealthDataScreen(BuildContext context, bool isDark) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.refreshData,
        color: AppColors.primaryLight,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(UIConstants.paddingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: UIConstants.paddingXL),
              // if (controller.hasData)
              Center(child: _buildHealthCards(isDark))
              // else
              //   Center(child: _buildNoDataState(context, isDark)),
              // const SizedBox(height: UIConstants.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      AppStrings.hi,
      style: AppTextStyles.h1.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 400))
        .slideX(begin: -0.2, end: 0);
  }

  Widget _buildHealthCards(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HealthCard(
          title: AppStrings.steps,
          value: controller.healthData.value.steps,
          goal: AppUtils.formatWithComma(controller.stepsGoal),
          progress: controller.stepsProgress,
          image: AppImages.steps,
          isDark: isDark,
        )
            .animate()
            .fadeIn(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 200),
            )
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: UIConstants.paddingXL * 2),
        HealthCard(
          title: AppStrings.caloriesBurned,
          value: controller.healthData.value.caloriesBurned,
          goal: AppUtils.formatWithComma(controller.caloriesGoal),
          progress: controller.caloriesProgress,
          image: AppImages.calories,
          isDark: isDark,
        )
            .animate()
            .fadeIn(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 300),
            )
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  // Widget _buildNoDataState(BuildContext context, bool isDark) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Icon(
  //         Icons.fitness_center,
  //         size: 80,
  //         color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
  //       ),
  //       const SizedBox(height: UIConstants.paddingXL),
  //       Text(
  //         AppStrings.noHealthData,
  //         style: AppTextStyles.h3.copyWith(
  //           color: Theme.of(context).colorScheme.onSurface,
  //         ),
  //       ),
  //       const SizedBox(height: UIConstants.paddingMD),
  //       Text(
  //         AppStrings.noHealthDataDesc,
  //         style: AppTextStyles.bodyMedium.copyWith(
  //           color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
  //         ),
  //         textAlign: TextAlign.center,
  //       ),
  //       const SizedBox(height: UIConstants.paddingXL),
  //       ElevatedButton(
  //         onPressed: controller.refreshData,
  //         child: const Text(AppStrings.refreshData),
  //       ),
  //     ],
  //   );
  // }
}
