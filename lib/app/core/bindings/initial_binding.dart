import 'package:get/get.dart';

import '../../data/services/health_service.dart';
import '../../data/services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<HealthService>(HealthService(), permanent: true);
  }
}
