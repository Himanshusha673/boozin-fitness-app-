import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/logger_utils.dart';
import '../models/health_data_model.dart';

class HealthService extends GetxService {
  final _logger = LoggerUtils.logger;
  late Health health;

  @override
  Future<void> onInit() async {
    super.onInit();
    health = Health();

    try {
      await health.configure();
    } catch (e) {
      _logger.e('Health configuration error: $e');
    }
  }

  Future<bool> isHealthConnectAvailable() async {
    try {
      final status = await health.getHealthConnectSdkStatus();

      if (status == HealthConnectSdkStatus.sdkUnavailable ||
          status ==
              HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> requestSystemPermissions() async {
    try {
      final activityStatus = await Permission.activityRecognition.request();

      return activityStatus.isGranted || activityStatus.isLimited;
    } catch (e) {
      return false;
    }
  }

  Future<bool> requestHealthPermissions() async {
    try {
      final isAvailable = await isHealthConnectAvailable();
      if (!isAvailable) {
        _logger.e('Health Connect is not available on this device');
        return false;
      }

      final types = [
        HealthDataType.STEPS,
        HealthDataType.ACTIVE_ENERGY_BURNED,
      ];

      bool? hasPerms = await health.hasPermissions(
        types,
        permissions: types.map((type) => HealthDataAccess.READ).toList(),
      );

      if (hasPerms == true) {
        return true;
      }
      bool authorized = await health.requestAuthorization(
        types,
        permissions: types.map((type) => HealthDataAccess.READ).toList(),
      );

      if (authorized) {
        try {
          await health.requestHealthDataHistoryAuthorization();
        } catch (e) {
          _logger.w('Historical data request failed (this is optional): $e');
        }
        return true;
      }

      return false;
    } catch (e) {
      _logger.e('Health permission error: $e');
      _logger.e('Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  Future<bool> hasPermissions() async {
    try {
      final types = [
        HealthDataType.STEPS,
        HealthDataType.ACTIVE_ENERGY_BURNED,
      ];

      final hasPerms = await health.hasPermissions(
        types,
        permissions: types.map((type) => HealthDataAccess.READ).toList(),
      );

      _logger.i('Has Health permissions: ${hasPerms ?? false}');
      return hasPerms ?? false;
    } catch (e) {
      _logger.e('Permission check error: $e');
      return false;
    }
  }

  Future<HealthDataModel> fetchTodayData() async {
    try {
      final now = DateTime.now();
      final startTime = DateTime(now.year, now.month, now.day, 0, 0, 0);

      int steps = await health.getTotalStepsInInterval(startTime, now) ?? 0;
      _logger.i('Steps retrieved: $steps');

      List<HealthDataPoint> calorieData = await health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: startTime,
        endTime: now,
      );

      _logger.i('Retrieved ${calorieData.length} calorie data points');

      double totalCalories = 0.0;
      for (var point in calorieData) {
        if (point.value is NumericHealthValue) {
          final value = (point.value as NumericHealthValue).numericValue;
          totalCalories += value.toDouble();
          _logger.d('Calorie point: $value at ${point.dateFrom}');
        }
      }

      return HealthDataModel(
        steps: steps,
        caloriesBurned: totalCalories,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      _logger.e('Error fetching health data: $e');
      return HealthDataModel.empty();
    }
  }

  Future<HealthDataModel> fetchHealthData({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      _logger.i('📊 Fetching health data from $startTime to $endTime');

      int steps = await health.getTotalStepsInInterval(startTime, endTime) ?? 0;

      List<HealthDataPoint> calorieData = await health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: startTime,
        endTime: endTime,
      );

      double totalCalories = 0.0;
      for (var point in calorieData) {
        if (point.value is NumericHealthValue) {
          totalCalories +=
              (point.value as NumericHealthValue).numericValue.toDouble();
        }
      }

      return HealthDataModel(
        steps: steps,
        caloriesBurned: totalCalories,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      _logger.e('Error fetching health data: $e');
      return HealthDataModel.empty();
    }
  }
}
