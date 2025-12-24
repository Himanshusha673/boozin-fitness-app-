import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late final GetStorage _storage;

  static const String keyFirstLaunch = 'first_launch';
  static const String keyThemeMode = 'theme_mode';

  @override
  void onInit() {
    super.onInit();
    _storage = GetStorage();
  }

  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  Future<void> clear() async {
    await _storage.erase();
  }

  bool get isFirstLaunch => read<bool>(keyFirstLaunch) ?? true;

  Future<void> setFirstLaunchComplete() async {
    await write(keyFirstLaunch, false);
  }
}
