import 'package:biddo/core/controllers/currencies.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

import '../repositories/ai.dart';
import 'account.dart';
import 'flash.dart';
import 'image_picker.dart';
import 'settings.dart';

class AiController extends GetxController {
  final settingsController = Get.find<SettingsController>();
  final imagePickerController = Get.find<ImagePickerController>();
  final aiRepository = Get.find<AIRepository>();
  final currenciesController = Get.find<CurrenciesController>();
  final accountController = Get.find<AccountController>();
  final flashController = Get.find<FlashController>();

  Future<GeneratedDataResult?> generateAuctionDataFromImages() async {
    var aiEnabled = settingsController.settings.value.aiEnabled;
    if (!aiEnabled) {
      flashController.showMessageFlash(tr('ai.ai_disabled'));
      return null;
    }

    var settings = settingsController.settings.value;
    var usedAiResponses = accountController.account.value.aiResponsesCount ?? 0;
    var maxAiResponsesReached =
        settings.maxAiResponsesPerUser <= usedAiResponses;

    if (maxAiResponsesReached) {
      flashController.showMessageFlash(tr('ai.max_ai_responses_reached'));
      return null;
    }

    var coinsToSpend = usedAiResponses < settings.freeAiResponses
        ? 0
        : settings.aiResponsesPriceInCoins;
    if (coinsToSpend > accountController.account.value.coins) {
      flashController.showMessageFlash(tr('ai.not_enough_coins'));
      return null;
    }

    var galleryAssets = await imagePickerController.getGalleryAssetPaths();
    var cameraAssets = imagePickerController.cameraAssets;

    var result = await aiRepository.generateData(
      currenciesController.selectedCurrency.value?.name['en'] ?? 'USD',
      galleryAssets,
      cameraAssets,
    );

    if (result == null) {
      return null;
    }

    accountController.account.value.aiResponsesCount = usedAiResponses + 1;
    accountController.account.value.coins -= coinsToSpend;
    accountController.account.refresh();

    return result;
  }
}
