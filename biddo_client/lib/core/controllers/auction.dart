import 'package:biddo/core/controllers/socket.dart';
import 'package:biddo/utils/generic.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:profanity_filter/profanity_filter.dart';

import '../models/auction.dart';
import '../models/auction_map_data.dart';
import '../models/category.dart';
import '../repositories/auction.dart';
import '../repositories/bid.dart';
import 'account.dart';
import 'categories.dart';
import 'favourites.dart';
import 'image_picker.dart';
import 'last_seen_auctions.dart';
import 'location.dart';
import 'settings.dart';

class AuctionController extends GetxController {
  final imagePickerController = Get.find<ImagePickerController>();
  final auctionRepository = Get.find<AuctionRepository>();
  final locationController = Get.find<LocationController>();
  final accountController = Get.find<AccountController>();
  final bidRepository = Get.find<BidRepository>();
  final lastSeenAuctionsController = Get.find<LastSeenAuctionsController>();
  final favouritesController = Get.find<FavouritesController>();
  final categoriesController = Get.find<CategoriesController>();
  final settingsController = Get.find<SettingsController>();
  final socketController = Get.find<SocketController>();

  // These properties are used inside the forms from the create and update auction screens
  late String id;
  Rx<String> description = ''.obs;
  Rx<String> title = ''.obs;
  Rx<String> mainCategoryId = ''.obs;
  Rx<String> subCategoryId = ''.obs;
  Rx<String> youtubeLink = ''.obs;
  Rx<double> startingPrice = 0.0.obs;
  Rx<bool> isCustomPriceSelected = false.obs;
  Rx<bool> customStartingDate = false.obs;
  Rx<String> initialCurrencyId = ''.obs;
  Rx<DateTime> startDate = DateTime.now().add(Duration(days: 1)).obs;
  Rx<DateTime> endDate = DateTime.now().add(Duration(days: 4)).obs;

  // These properties are used to store auctions lists
  RxList<Rx<Auction>> recommended = RxList<Rx<Auction>>();
  RxList<Rx<Auction>> auctions = RxList<Rx<Auction>>();
  RxList<Rx<Auction>> startingSoonAuctions = RxList<Rx<Auction>>();
  RxInt allActiveAuctionsCount = 0.obs;

  Rx<AuctionProductCondition> condition =
      AuctionProductCondition.newProduct.obs;

  @override
  void onClose() {
    recommended.clear();
    auctions.clear();
    allActiveAuctionsCount.value = 0;
    super.onClose();
  }

  Future<List<Auction>?> loadSimilarAuctions(String auctionId,
      [int page = 0, int perPage = 10]) async {
    return await auctionRepository.loadSimilarAuctions(auctionId);
  }

  Future<void> loadAuctionsLists() async {
    var initialRecommendationsLoad = refreshRecommendations();
    var activeAuctionsCountLoad = auctionRepository.countFilter(
      [],
      [],
      [],
      true,
    );
    var latestAuctionsLoad = auctionRepository.loadLatestAuctions();
    var startingSoonAuctionsLoad = getStartingSoonAuctions(0, 5);

    await initialRecommendationsLoad;
    var latestAuctions = await latestAuctionsLoad;
    var activeAuctionsCount = await activeAuctionsCountLoad;
    var startingSoonAuctionsData = await startingSoonAuctionsLoad;

    auctions.clear();
    auctions.addAll(latestAuctions!.map((e) => e.obs).toList());
    allActiveAuctionsCount.value = activeAuctionsCount;

    startingSoonAuctions.clear();
    startingSoonAuctions
        .addAll(startingSoonAuctionsData.map((e) => e.obs).toList());

    auctions.refresh();
    allActiveAuctionsCount.refresh();
    startingSoonAuctions.refresh();
  }

  Future<void> refreshRecommendations() async {
    var recommendedAuctions = await auctionRepository.loadRecommendations();
    recommended.clear();
    recommended.addAll(recommendedAuctions.map((e) => e.obs).toList());
    recommended.refresh();
  }

  void initForUpdate(Auction auction) {
    id = auction.id;
    description.value = auction.description;
    title.value = auction.title;
    mainCategoryId.value = auction.mainCategoryId;
    subCategoryId.value = auction.subCategoryId;
    startingPrice.value = auction.startingPrice;
    isCustomPriceSelected.value = auction.hasCustomStartingPrice ?? false;
    condition.value = auction.condition;
    youtubeLink.value = auction.youtubeLink ?? '';
    initialCurrencyId.value = auction.initialCurrencyId ?? '';

    if (auction.startAt != null) {
      customStartingDate.value = true;
      startDate.value = auction.startAt!;
      endDate.value = auction.expiresAt!;
    }

    imagePickerController.setNetworkAssets(auction.assets ?? []);
    locationController.setMarkerLatLong(auction.location);
    locationController.setLocation(auction.locationPretty ?? '');
  }

  void setStartingPrice(double value, bool isCustomPrice) {
    if (startingPrice.value == value &&
        isCustomPriceSelected.value == isCustomPrice) {
      return;
    }

    initialCurrencyId.value = getInitialCurrencyId() ?? '';

    startingPrice.value = value;
    isCustomPriceSelected.value = isCustomPrice;

    startingPrice.refresh();
    isCustomPriceSelected.refresh();
  }

  bool startingPriceIsSelected(int value, bool isCustomPrice) {
    return startingPrice.value == value &&
        isCustomPriceSelected.value == isCustomPrice;
  }

  void setDescription(String newDescription) {
    description.value = newDescription;
  }

  void setYoutubeLink(String newLink) {
    youtubeLink.value = newLink;
  }

  void setTitle(String newTitle) {
    title.value = newTitle;
  }

  void setCondition(AuctionProductCondition newCondition) {
    condition.value = newCondition;
  }

  Future<List<AuctionMapData>> loadAuctionsForMap() async {
    return await auctionRepository.loadAuctionsForMap();
  }

  Future<List<Auction>> getManySummary(List<String> auctionIds) async {
    return await auctionRepository.getManySummary(auctionIds);
  }

  String? getInitialCurrencyId() {
    if (accountController.account.value.selectedCurrencyId != null) {
      return accountController.account.value.selectedCurrencyId!;
    }

    return settingsController.settings.value.defaultCurrencyId;
  }

  Future<Auction?> create() async {
    final filter = ProfanityFilter();

    var galleryAssets = await imagePickerController.getGalleryAssetPaths();
    var youtubeLinkValue =
        GenericUtils.containsInappropriateKeywords(youtubeLink.value)
            ? ''
            : youtubeLink.value;

    var currencyId = getInitialCurrencyId();

    var createdAuction = await auctionRepository.create(
      CreateUpdateAuctionParams(
        latLng: locationController.latLng.value as LatLng,
        location: locationController.location.value,
        description: filter.censor(description.value),
        galleryAssets: galleryAssets,
        cameraAssets: imagePickerController.cameraAssets,
        hasCustomStartingPrice: isCustomPriceSelected.value,
        mainCategoryId: mainCategoryId.value,
        subCategoryId: subCategoryId.value,
        youtubeLink: youtubeLinkValue,
        price: startingPrice.value,
        initialCurrencyId: currencyId,
        startAt: customStartingDate.value ? startDate.value : null,
        expiresAt: customStartingDate.value ? endDate.value : null,
        title: filter.censor(title.value),
        condition: condition.value == AuctionProductCondition.newProduct
            ? 'new'
            : 'used',
      ),
    );

    if (createdAuction == null) {
      return null;
    }

    accountController.saveLocationToAccount(
      locationController.latLng.value as LatLng,
      locationController.location.value,
    );

    categoriesController.incrementCategoryAuctionCount(mainCategoryId.value);

    accountController.accountAuctionsCount.value += 1;
    accountController.accountAuctionsCount.refresh();

    accountController.activeAuctionsCount.value += 1;
    accountController.activeAuctionsCount.refresh();

    if (customStartingDate.value == false) {
      auctions.insert(0, createdAuction.obs);
      auctions.refresh();
      allActiveAuctionsCount.value += 1;
    } else {
      startingSoonAuctions.insert(0, createdAuction.obs);
      startingSoonAuctions.refresh();
    }
    clear();

    return createdAuction;
  }

  Future<bool> promote(String auctionId) async {
    var promoted = await auctionRepository.promote(auctionId);
    if (promoted) {
      accountController.account.value.coins -=
          settingsController.settings.value.promotionCoinsCost;
      accountController.account.refresh();
    }
    return promoted;
  }

  Future<AuctionTranslationResult?> translateDetails(
    String auctionId,
    String lang,
  ) async {
    return await auctionRepository.translateDetails(auctionId, lang);
  }

  Future<Auction?> updateAuction(Auction auction) async {
    var galleryAssets = await imagePickerController.getGalleryAssetPaths();
    var networkAssets = imagePickerController.networkAssets;
    final filter = ProfanityFilter();

    var youtubeLinkValue =
        GenericUtils.containsInappropriateKeywords(youtubeLink.value)
            ? ''
            : youtubeLink.value;

    var currencyId = getInitialCurrencyId();

    var updated = await auctionRepository.update(
      CreateUpdateAuctionParams(
        id: auction.id,
        latLng: locationController.latLng.value as LatLng,
        location: locationController.location.value,
        description: filter.censor(description.value),
        galleryAssets: galleryAssets,
        cameraAssets: imagePickerController.cameraAssets,
        hasCustomStartingPrice: isCustomPriceSelected.value,
        mainCategoryId: mainCategoryId.value,
        subCategoryId: subCategoryId.value,
        initialCurrencyId: currencyId,
        youtubeLink: youtubeLinkValue,
        assetsToKeep: networkAssets.map((e) => e.id).toList(),
        startAt: customStartingDate.value ? startDate.value : null,
        expiresAt: customStartingDate.value ? endDate.value : null,
        price: startingPrice.value,
        title: filter.censor(title.value),
        condition: condition.value == AuctionProductCondition.newProduct
            ? 'new'
            : 'used',
      ),
    );

    if (updated != null) {
      accountController.saveLocationToAccount(
        locationController.latLng.value as LatLng,
        locationController.location.value,
      );

      clear();
    }

    return updated;
  }

  Future<bool> deleteAuction(Rx<Auction> auction) async {
    var deleted = await auctionRepository.delete(auction.value.id);
    if (!deleted) {
      return false;
    }

    categoriesController
        .decrementCategoryAuctionCount(auction.value.mainCategoryId);

    auctions.removeWhere((element) => element.value.id == auction.value.id);
    startingSoonAuctions
        .removeWhere((element) => element.value.id == auction.value.id);
    lastSeenAuctionsController.removeAuctionById(auction.value.id);
    favouritesController.removeAuctionFromFavourites(auction.value.id, false);

    accountController.accountAuctionsCount.value -= 1;
    accountController.accountAuctionsCount.refresh();

    if (auction.value.isActive) {
      allActiveAuctionsCount.value -= 1;
      accountController.activeAuctionsCount.value -= 1;
      if (accountController.activeAuctionsCount < 0) {
        accountController.activeAuctionsCount.value = 0;
      }

      allActiveAuctionsCount.refresh();
      accountController.activeAuctionsCount.refresh();
    } else {
      accountController.closedAuctionsCount.value -= 1;
      if (accountController.closedAuctionsCount < 0) {
        accountController.closedAuctionsCount.value = 0;
      }
      accountController.closedAuctionsCount.refresh();
    }

    auction.close();
    return deleted;
  }

  Future<List<Auction>> loadForAccount(
    String status,
    int page,
    int pageSize, [
    String query = '',
    AuctionsSortBy? sortBy = AuctionsSortBy.oldest,
  ]) {
    return auctionRepository.loadForAccount(
      status,
      page,
      pageSize,
      query,
      sortBy,
    );
  }

  Future<List<Auction>> loadRecommendations(int page, int pageSize) {
    return auctionRepository.loadRecommendations(page, pageSize);
  }

  Future<List<Auction>> loadByProximity(
    LatLng latlng,
    String mainCategoryId, [
    int distance = 10,
  ]) {
    return auctionRepository.loadByProximity(latlng, mainCategoryId, distance);
  }

  Future<List<Auction>> getStartingSoonAuctions(
    int page,
    int pageSize, [
    AuctionsSortBy? sortBy = AuctionsSortBy.oldest,
  ]) async {
    return await auctionRepository.loadFilteredAuctions(
      [],
      [],
      [],
      true,
      page,
      pageSize,
      '',
      sortBy,
      true,
      0,
      0,
      false,
    );
  }

  Future<List<Auction>> loadAuctionsByPage(
    int page,
    int pageSize, [
    String query = '',
    AuctionsSortBy? sortBy = AuctionsSortBy.oldest,
    List<Category> categories = const [],
    List<Category> subCategories = const [],
    List<Category> locations = const [],
  ]) async {
    return await auctionRepository.loadFilteredAuctions(
      categories.map((e) => e.id).toList(),
      subCategories.map((e) => e.id).toList(),
      locations.map((e) => e.id).toList(),
      true,
      page,
      pageSize,
      query,
      sortBy,
    );
  }

  Future<List<Auction>> loadActiveForAccount(
    String accountId,
    int page,
    int pageSize, [
    String query = '',
    AuctionsSortBy? sortBy = AuctionsSortBy.oldest,
  ]) {
    return auctionRepository.loadActiveForAccount(
      accountId,
      page,
      pageSize,
      query,
      sortBy,
    );
  }

  Future<Auction?> loadDetails(String auctionId) async {
    return await auctionRepository.loadDetails(auctionId);
  }

  void clear() {
    description.value = '';
    title.value = '';
    mainCategoryId.value = '';
    subCategoryId.value = '';
    startingPrice.value = 0.0;
    youtubeLink.value = '';
    initialCurrencyId.value = '';
    isCustomPriceSelected.value = false;
    condition.value = AuctionProductCondition.newProduct;
    customStartingDate.value = false;
    startDate.value = DateTime.now().add(Duration(days: 1));
    endDate.value = DateTime.now().add(Duration(days: 4));

    imagePickerController.clear();
  }
}
