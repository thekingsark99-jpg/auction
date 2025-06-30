import 'package:biddo/core/models/settings.dart';
import 'package:get/get.dart';

import '../repositories/settings.dart';

class SettingsController extends GetxController {
  final settingsRepository = Get.find<SettingsRepository>();

  Rx<BiddoSettings> settings = BiddoSettings().obs;

  Future<BiddoSettings> load() async {
    var settingsData = await settingsRepository.getSettings();
    settings.value = settingsData;
    return settings.value;
  }
}
