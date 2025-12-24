import 'package:flutter/material.dart';
import '../../../config/constants/app_strings.dart';
import '../../../config/constants/ui_constants.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';

class PermissionWidget extends StatelessWidget {
  final PermissionState permissionState;
  final String permissionMessage;
  final VoidCallback onRequestPermissions;
  final bool isDark;

  const PermissionWidget({
    super.key,
    required this.permissionState,
    required this.permissionMessage,
    required this.onRequestPermissions,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UIConstants.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(),
          const SizedBox(height: UIConstants.paddingXL),
          Text(
            _getTitle(),
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.paddingMD),
          Text(
            permissionMessage,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.paddingXL),
          _buildActionButton(),
          if (permissionState == PermissionState.healthConnectNotAvailable)
            _buildHealthConnectInstructions(),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (permissionState) {
      case PermissionState.needsSystemPermission:
        return AppStrings.systemPermissionRequired;
      case PermissionState.needsHealthPermission:
        return AppStrings.healthConnectAccess;
      case PermissionState.healthConnectNotAvailable:
        return AppStrings.healthConnectNotFound;
      case PermissionState.denied:
        return AppStrings.permissionDenied;
      default:
        return AppStrings.permissionsRequired;
    }
  }

  Widget _buildActionButton() {
    switch (permissionState) {
      case PermissionState.needsSystemPermission:
      case PermissionState.needsHealthPermission:
        return ElevatedButton(
          onPressed: onRequestPermissions,
          child: const Text(AppStrings.grantPermissions),
        );
      case PermissionState.healthConnectNotAvailable:
        return Column(
          children: [
            ElevatedButton(
              onPressed: onRequestPermissions,
              child: const Text(AppStrings.installHealthConnect),
            ),
            const SizedBox(height: UIConstants.paddingMD),
            OutlinedButton(
              onPressed: onRequestPermissions,
              child: const Text(AppStrings.checkAgain),
            ),
          ],
        );
      case PermissionState.denied:
        return ElevatedButton(
          onPressed: onRequestPermissions,
          child: const Text(AppStrings.tryAgain),
        );
      default:
        return ElevatedButton(
          onPressed: onRequestPermissions,
          child: const Text(AppStrings.continueText),
        );
    }
  }

  Widget _buildHealthConnectInstructions() {
    return Column(
      children: [
        const SizedBox(height: UIConstants.paddingXL),
        Text(
          AppStrings.howToInstallHealthConnect,
          style: AppTextStyles.h4,
        ),
        const SizedBox(height: UIConstants.paddingSM),
        _instruction(AppStrings.instruction1),
        _instruction(AppStrings.instruction2),
        _instruction(AppStrings.instruction3),
        _instruction(AppStrings.instruction4),
        _instruction(AppStrings.instruction5),
      ],
    );
  }

  Widget _instruction(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UIConstants.paddingXS),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Icon(
      Icons.health_and_safety,
      size: 80,
      color: AppColors.primaryLight,
    );
  }
}
