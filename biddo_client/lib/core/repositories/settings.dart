import 'package:biddo/core/models/settings.dart';
import 'package:get/get.dart';

import 'base.dart';

class SettingsRepository {
  final dio = Get.find<Api>();

  Future<BiddoSettings> getSettings() async {
    try {
      var response = await dio.api.get('/settings');
      return BiddoSettings.fromJSON(response.data);
    } catch (error) {
      print('error loading settings: $error');
      return BiddoSettings();
    }
  }
}
