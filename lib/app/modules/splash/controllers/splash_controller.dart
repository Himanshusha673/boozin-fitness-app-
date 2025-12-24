import 'package:get/get.dart';

import '../../../data/services/storage_service.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/logger_utils.dart';

class SplashController extends GetxController {
  final _logger = LoggerUtils.logger;
  final _storageService = Get.find<StorageService>();

  final isAnimationComplete = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // _logger.i('Initializing app...');

      await Future.delayed(const Duration(milliseconds: 2500));
      isAnimationComplete.value = true;

      if (_storageService.isFirstLaunch) {
        await _storageService.setFirstLaunchComplete();
      }

      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      _logger.e('Error during app initialization: $e');

      Get.offAllNamed(Routes.HOME);
    }
  }
}
