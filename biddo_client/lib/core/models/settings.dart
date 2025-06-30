// The default crendetials are test ad unit IDs from Google AdMob
import 'dart:io';

import 'package:flutter_config/flutter_config.dart';

import '../../utils/constants.dart';

const defaultCredentials = {
  'android': {
    'banner': 'ca-app-pub-3940256099942544/6300978111',
    'interstitial': 'ca-app-pub-3940256099942544/1033173712',
    'rewarded': 'ca-app-pub-3940256099942544/5224354917',
  },
  'ios': {
    'banner': 'ca-app-pub-3940256099942544/2934735716',
    'interstitial': 'ca-app-pub-3940256099942544/4411468910',
    'rewarded': 'ca-app-pub-3940256099942544/1712485313',
  },
};

class BiddoSettings {
  AdsCredentials? adsCredentials;
  bool adsEnabled;
  String? defaultCurrencyId;
  String appName;

  int auctionActiveTimeInHours;
  int maxAllowedDistanceBetweenUsersInKM;
  int maxProductPrice;
  int promotionCoinsCost;
  int rewardCoinsForWatchingAd;

  String defaultProductImageUrl;
  String confidentialityLink;
  String? revenueCatAndroidKey;
  String? revenueCatIOSKey;

  int freeAuctionsCount;
  int freeBidsCount;
  int auctionsCoinsCost;
  int bidsCoinsCost;

  bool aiEnabled;

  bool emailValidationEnabled;
  bool allowUnvalidatedUsersToCreateAuctions;
  bool allowUnvalidatedUsersToCreateBids;
  bool allowAnonymousUsersToCreateAuctions;
  bool allowAnonymousUsersToCreateBids;

  bool allowMultipleCurrencies;

  bool allowValidationRequest;

  bool allowAiResponsesOnUnvalidatedEmails;
  int freeAiResponses;
  int aiResponsesPriceInCoins;
  int maxAiResponsesPerUser;

  BiddoSettings({
    this.adsEnabled = true,
    this.adsCredentials,
    this.rewardCoinsForWatchingAd = 1,
    this.defaultCurrencyId,
    this.allowMultipleCurrencies = true,
    this.auctionActiveTimeInHours = Constants.AUCTION_ACTIVE_TIME_IN_HOURS,
    this.maxAllowedDistanceBetweenUsersInKM =
        Constants.MAX_ALLOWED_DISTANCE_BETWEEN_USERS_IN_KM,
    this.maxProductPrice = Constants.MAX_ITEM_PRICE,
    this.promotionCoinsCost = Constants.PROMOTION_COINS_COST,
    this.defaultProductImageUrl = Constants.DEFAULT_ITEM_IMAGE,
    this.confidentialityLink = '',
    this.revenueCatAndroidKey,
    this.aiEnabled = false,
    this.appName = 'Biddo',
    this.revenueCatIOSKey,
    this.emailValidationEnabled = true,
    this.freeAuctionsCount = Constants.FREE_AUCTIONS_COUNT,
    this.freeBidsCount = Constants.FREE_BIDS_COUNT,
    this.auctionsCoinsCost = Constants.AUCTIONS_COINS_COST,
    this.bidsCoinsCost = Constants.BIDS_COINS_COST,
    this.allowValidationRequest = true,
    this.allowUnvalidatedUsersToCreateAuctions = true,
    this.allowUnvalidatedUsersToCreateBids = true,
    this.allowAnonymousUsersToCreateAuctions = true,
    this.allowAnonymousUsersToCreateBids = true,
    this.allowAiResponsesOnUnvalidatedEmails = true,
    this.freeAiResponses = 0,
    this.aiResponsesPriceInCoins = 0,
    this.maxAiResponsesPerUser = 0,
  });

  static BiddoSettings fromJSON(dynamic data) {
    var adsEnabled = Platform.isAndroid
        ? data['adsEnabledOnAndroid']
        : data['adsEnabledOnIOS'];

    var credentials = Platform.isAndroid
        ? data['androidAdsCredentials'] ?? defaultCredentials['android']
        : data['iosAdsCredentials'] ?? defaultCredentials['ios'];

    return BiddoSettings(
      adsCredentials: AdsCredentials.fromJSON(credentials),
      adsEnabled: adsEnabled ?? true,
      appName: data['appName'] ?? 'Biddo',
      allowMultipleCurrencies: data['allowMultipleCurrencies'] ?? true,
      defaultCurrencyId: data['defaultCurrencyId'],
      auctionActiveTimeInHours: data['auctionActiveTimeInHours'] ??
          Constants.AUCTION_ACTIVE_TIME_IN_HOURS,
      maxAllowedDistanceBetweenUsersInKM:
          data['maxAllowedDistanceBetweenUsersInKM'] ??
              Constants.MAX_ALLOWED_DISTANCE_BETWEEN_USERS_IN_KM,
      maxProductPrice: data['maxProductPrice'] ?? Constants.MAX_ITEM_PRICE,
      aiEnabled: data['aiEnabled'] ?? false,
      promotionCoinsCost:
          data['promotionCoinsCost'] ?? Constants.PROMOTION_COINS_COST,
      defaultProductImageUrl:
          data['defaultProductImageUrl'] ?? Constants.DEFAULT_ITEM_IMAGE,
      confidentialityLink: data['confidentialityLink'] ??
          FlutterConfig.get('CONFIDENTIALITY_LINK'),
      revenueCatAndroidKey: data['revenueCatAndroidKey'] ??
          FlutterConfig.get('REVENUE_CAT_GOOGLE_API_KEY'),
      revenueCatIOSKey: data['revenueCatIOSKey'] ??
          FlutterConfig.get('REVENUE_CAT_IOS_API_KEY'),
      rewardCoinsForWatchingAd: data['rewardCoinsForWatchingAd'] ?? 1,
      freeAuctionsCount:
          data['freeAuctionsCount'] ?? Constants.FREE_AUCTIONS_COUNT,
      freeBidsCount: data['freeBidsCount'] ?? Constants.FREE_BIDS_COUNT,
      auctionsCoinsCost:
          data['auctionsCoinsCost'] ?? Constants.AUCTIONS_COINS_COST,
      allowValidationRequest: data['allowValidationRequest'] ?? true,
      bidsCoinsCost: data['bidsCoinsCost'] ?? Constants.BIDS_COINS_COST,
      emailValidationEnabled: data['emailValidationEnabled'] ?? true,
      allowAiResponsesOnUnvalidatedEmails:
          data['allowAiResponsesOnUnvalidatedEmails'] ?? false,
      freeAiResponses: data['freeAiResponses'] ?? 0,
      aiResponsesPriceInCoins: data['aiResponsesPriceInCoins'] ?? 0,
      maxAiResponsesPerUser: data['maxAiResponsesPerUser'] ?? 0,
      allowUnvalidatedUsersToCreateAuctions:
          data['allowUnvalidatedUsersToCreateAuctions'] ?? true,
      allowUnvalidatedUsersToCreateBids:
          data['allowUnvalidatedUsersToCreateBids'] ?? true,
      allowAnonymousUsersToCreateAuctions:
          data['allowAnonymousUsersToCreateAuctions'] ?? true,
      allowAnonymousUsersToCreateBids:
          data['allowAnonymousUsersToCreateBids'] ?? true,
    );
  }
}

class AdsCredentials {
  final String banner;
  final String interstitial;
  final String rewarded;

  AdsCredentials({
    required this.banner,
    required this.interstitial,
    required this.rewarded,
  });

  static AdsCredentials fromJSON(dynamic data) {
    return AdsCredentials(
      banner: data['banner'],
      interstitial: data['interstitial'],
      rewarded: data['rewarded'],
    );
  }
}
