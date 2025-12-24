
import 'package:get/get.dart';

import '../../../config/constants/app_strings.dart';
import '../../../data/models/health_data_model.dart';
import '../../../data/services/health_service.dart';
import '../../../utils/logger_utils.dart';

enum PermissionState {
  initial,
  checking,
  granted,
  needsSystemPermission,
  needsHealthPermission,
  healthConnectNotAvailable,
  denied,
  showingPermissionDialog,
}

class HomeController extends GetxController {
  final _logger = LoggerUtils.logger;
  final _healthService = Get.find<HealthService>();

  final healthData = Rx<HealthDataModel>(HealthDataModel.empty());
  final isLoading = false.obs;
  final permissionState = Rx<PermissionState>(PermissionState.initial);

  final stepsGoal = 15000;
  final caloriesGoal = 1000;

  bool get hasData =>
      healthData.value.steps > 0 || healthData.value.caloriesBurned > 0;
  bool get needsPermission =>
      permissionState.value == PermissionState.needsSystemPermission ||
      permissionState.value == PermissionState.needsHealthPermission ||
      permissionState.value == PermissionState.healthConnectNotAvailable ||
      permissionState.value == PermissionState.denied ||
      permissionState.value == PermissionState.showingPermissionDialog;

  bool _permissionDialogShown = false;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    permissionState.value = PermissionState.checking;
    isLoading.value = true;

    try {
      final isAvailable = await _healthService.isHealthConnectAvailable();

      if (!isAvailable) {
        permissionState.value = PermissionState.healthConnectNotAvailable;
        isLoading.value = false;
        _showHealthConnectDialog();
        return;
      }

      final hasHealthPerms = await _healthService.hasPermissions();

      if (hasHealthPerms) {
        permissionState.value = PermissionState.granted;
        await _loadData();
      } else {
        permissionState.value = PermissionState.needsSystemPermission;

        if (!_permissionDialogShown) {
          Future.delayed(const Duration(milliseconds: 300), () {
            _showPermissionDialog();
          });
        }
      }
    } catch (e) {
      _logger.e(e);
      permissionState.value = PermissionState.denied;
    } finally {
      isLoading.value = false;
    }
  }

  void _showPermissionDialog() {
    if (_permissionDialogShown) return;
    _permissionDialogShown = true;

    permissionState.value = PermissionState.showingPermissionDialog;

    Get.defaultDialog(
      title: AppStrings.permissionsRequired,
      middleText: permissionMessage,
      textConfirm: AppStrings.grantPermissions,
      // confirmTextColor: AppColors.surfaceLight,
      onConfirm: () async {
        Get.back();
        await requestPermissions();
      },
      onCancel: () {
        permissionState.value = PermissionState.denied;
      },
      barrierDismissible: false,
    );
  }

  void _showHealthConnectDialog() {
    Get.defaultDialog(
      title: AppStrings.healthConnectRequired,
      middleText: AppStrings.healthConnectMissing,
      textConfirm: AppStrings.okay,
      onConfirm: () => Get.back(),
      barrierDismissible: false,
    );
  }

  Future<void> requestPermissions() async {
    isLoading.value = true;

    try {
      final isAvailable = await _healthService.isHealthConnectAvailable();

      if (!isAvailable) {
        permissionState.value = PermissionState.healthConnectNotAvailable;
        _showHealthConnectDialog();
        return;
      }

      final systemGranted = await _healthService.requestSystemPermissions();

      if (!systemGranted) {
        permissionState.value = PermissionState.denied;
        Get.snackbar(
          AppStrings.error,
          AppStrings.systemPermissionDenied,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await Future.delayed(const Duration(milliseconds: 500));

      final healthGranted = await _healthService.requestHealthPermissions();

      if (healthGranted) {
        permissionState.value = PermissionState.granted;
        await _loadData();

        Get.snackbar(
          AppStrings.success,
          AppStrings.permissionsGranted,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        permissionState.value = PermissionState.denied;
        Get.snackbar(
          AppStrings.error,
          AppStrings.healthPermissionDenied,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void showPermissionDialogManually() {
    if (needsPermission && permissionState.value != PermissionState.granted) {
      _showPermissionDialog();
    }
  }

  Future<void> _loadData() async {
    final data = await _healthService.fetchTodayData();
    healthData.value = data;
  }

  Future<void> refreshData() async {
    if (permissionState.value != PermissionState.granted) return;
    await _loadData();
  }

  double get stepsProgress =>
      (healthData.value.steps / stepsGoal).clamp(0.0, 1.0);

  double get caloriesProgress =>
      (healthData.value.caloriesBurned / caloriesGoal).clamp(0.0, 1.0);

  String get permissionMessage {
    switch (permissionState.value) {
      case PermissionState.checking:
        return AppStrings.checkingPermissions;
      case PermissionState.needsSystemPermission:
        return AppStrings.needSystemPermission;
      case PermissionState.needsHealthPermission:
        return AppStrings.needHealthPermission;
      case PermissionState.healthConnectNotAvailable:
        return AppStrings.healthConnectMissing;
      case PermissionState.denied:
        return AppStrings.permissionDeniedMessage;
      case PermissionState.granted:
        return AppStrings.permissionsGranted;
      case PermissionState.showingPermissionDialog:
        return AppStrings.permissionsRequiredDescription;
      default:
        return AppStrings.permissionsRequired;
    }
  }
}
