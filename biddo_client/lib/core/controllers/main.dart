import 'dart:async';
import 'dart:io';

import 'package:biddo/core/controllers/account.dart';
import 'package:biddo/core/controllers/chat.dart';
import 'package:biddo/core/controllers/secured.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import '../models/settings.dart';
import '../repositories/auction.dart';
import '../repositories/main.dart';
import '../repositories/report.dart';
import '../services/auth.dart';
import '../services/connectivity.dart';
import '../services/lang_detector.dart';
import '../services/socket.dart';
import 'auction.dart';
import 'categories.dart';
import 'currencies.dart';
import 'favourites.dart';
import 'last_seen_auctions.dart';
import 'notifications.dart';
import 'payments.dart';
import 'search.dart';
import 'settings.dart';
import 'socket.dart';
import 'terms.dart';

class MainController extends GetxController {
  final connectivityService = Get.find<ConnectivityService>();
  final authService = Get.find<AuthService>();
  final securedController = Get.find<SecuredController>();
  final accountController = Get.find<AccountController>();
  final favouritesController = Get.find<FavouritesController>();
  final termsAndConditionsController = Get.find<TermsAndConditionController>();
  final socketService = Get.find<SocketService>();
  final socketController = Get.find<SocketController>();
  final mainRepository = Get.find<MainRepository>();
  final categoriesController = Get.find<CategoriesController>();
  final lastSeenAuctionsController = Get.find<LastSeenAuctionsController>();
  final auctionRepository = Get.find<AuctionRepository>();
  final searchController = Get.find<SearchController>();
  final reportsRepository = Get.find<ReportsRepository>();
  final notificationsController = Get.find<NotificationsController>();
  final chatController = Get.find<ChatController>();
  final auctionsController = Get.find<AuctionController>();
  final paymentsController = Get.find<PaymentsController>();
  final settingsController = Get.find<SettingsController>();
  final languageDetectorService = Get.find<LanguageDetectorService>();
  final currenciesController = Get.find<CurrenciesController>();

  RxList<ConnectivityResult> connectivity = RxList<ConnectivityResult>();
  late StreamSubscription<User?> _authSubscription;

  @override
  void onInit() async {
    super.onInit();

    _authSubscription = authService.firebaseUser.listen((value) async {
      if (value == null) {
        securedController.setJwt('');
        return;
      }
      authService.signinIn.value = true;

      var jwtToken = await value.getIdToken();
      if (jwtToken == null) {
        authService.signinIn.value = false;
        return;
      }

      await securedController.setJwt(jwtToken);
      var purchasesAreAvailable = purchasesAvailable();
      var loaded =
          await accountController.loadAccountData(purchasesAreAvailable);
      if (loaded) {
        await loadSettings();
        await initializeAppRequiredData();
      }

      authService.signinIn.value = false;
    });

    connectivityService.init((connectivity) {
      this.connectivity.value = connectivity;
    });

    socketController.setHandler(
      CustomMessages.myAuctionStarted,
      handleAuctionStartedEvent,
    );

    socketController.setHandler(
      CustomMessages.auctionFromFavouritesStarted,
      handleAuctionStartedEvent,
    );

    await languageDetectorService.init();
  }

  @override
  void onClose() {
    super.onClose();
    connectivityService.dispose();
    _authSubscription.cancel();
  }

  void handleAuctionStartedEvent(dynamic data) {
    try {
      var auctionId = data['dataValues']['entityId'];
      if (auctionId == null) {
        return;
      }

      // remove the auction from the list of auctions
      auctionsController.startingSoonAuctions
          .removeWhere((element) => element.value.id == auctionId);
      auctionsController.startingSoonAuctions.refresh();

      // Update favourites started auctions
      for (var element in favouritesController.favourites) {
        if (element.value.id == auctionId) {
          element.value.startedAt = DateTime.now();
          element.value.isActive = true;
          element.refresh();
        }
      }
    } catch (error) {
      print('Error in handleMyAuctionStarted: $error');
    }
  }

  Future<bool> createReport(
    String entity,
    String entityId,
    String reason, [
    String description = '',
  ]) async {
    return await reportsRepository.create(
      entity,
      entityId,
      reason,
      description,
    );
  }

  Future<void> recheckNetworkConnectivity() async {
    return connectivityService.recheckConnectivity();
  }

  Future<bool> checkIfServerIsRunning() async {
    return await mainRepository.serverIsRunning();
  }

  Future<void> signOut() async {
    clear();
    await authService.signOut();
  }

  Future<bool> loadAccount() async {
    await securedController.loadJwtFromStorage();
    if (securedController.jwt.value == '') {
      return false;
    }

    var purchasesAreAvailable = purchasesAvailable();
    await accountController.loadAccountData(purchasesAreAvailable);
    return true;
  }

  Future<bool> sendUsAMessage(String message) {
    return mainRepository.sendUsAMessage(message);
  }

  bool purchasesAvailable() {
    var iosKey = FlutterConfig.get('REVENUE_CAT_IOS_API_KEY');
    var androidKey = FlutterConfig.get('REVENUE_CAT_GOOGLE_API_KEY');

    return (iosKey != null &&
            iosKey.length > 0 &&
            (Platform.isIOS || Platform.isMacOS)) ||
        (androidKey != null && androidKey.length > 0 && Platform.isAndroid);
  }

  Future<BiddoSettings> loadSettings() async {
    var settings = await settingsController.load();
    return settings;
  }

  Future<void> initializeAppRequiredData() async {
    var purchasesAreAvailable = purchasesAvailable();

    favouritesController.load();
    lastSeenAuctionsController.load();
    searchController.load();
    notificationsController.loadForAccount();
    chatController.init();
    paymentsController.init(purchasesAreAvailable);

    var currenciesDataLoad = currenciesController.load();
    var categoriesDataLoad = categoriesController.load();
    var auctionsDataLoad = auctionsController.loadAuctionsLists();

    await categoriesDataLoad;
    await auctionsDataLoad;
    await currenciesDataLoad;
  }

  void clear() {
    accountController.clearAccount();
    securedController.setJwt('');
    favouritesController.clear();
    termsAndConditionsController.clear();
    socketService.clearSocket();
    chatController.clear();
  }
}
