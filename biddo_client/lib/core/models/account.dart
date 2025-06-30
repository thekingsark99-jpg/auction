// ignore_for_file: non_constant_identifier_names

import 'package:biddo/core/models/asset.dart';
import 'package:biddo/core/models/review.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'auction.dart';
import 'filter.dart';

class Account {
  String id;
  String? name;
  String email;
  String picture;
  bool isAnonymous;
  String? deviceFCMToken;
  bool acceptedTermsAndCondition;
  int? activeAuctionsCount;

  String? selectedCurrencyId;

  List<Auction> auctions;
  List<Review> reviews;
  List<String>? blockedAccounts;

  String? phone;

  AccountMetadata? meta;
  AccountNotifications? allowedNotifications;

  int? followersCount;
  int? followingCount;

  int? reviewsCount;
  double? reviewsAverage;

  int? aiResponsesCount;

  bool introDone;
  bool introSkipped;

  int coins;

  bool categoriesSetupDone;
  List<String> preferredCategoriesIds;

  List<String>? followedByAccountsIds;
  List<String>? followingAccountsIds;
  List<FilterItem>? filters;

  bool verified;
  DateTime? verifiedAt;
  DateTime? verificationRequestedAt;

  LatLng? locationLatLng;
  String? locationPretty;

  DateTime? createdAt;
  DateTime? updatedAt;

  Account({
    this.id = '',
    this.email = '',
    this.name = '',
    this.picture = '',
    this.isAnonymous = false,
    this.locationLatLng,
    this.locationPretty,
    this.selectedCurrencyId,
    this.acceptedTermsAndCondition = false,
    this.deviceFCMToken = '',
    this.introDone = false,
    this.introSkipped = false,
    this.auctions = const [],
    this.reviews = const [],
    this.blockedAccounts = const [],
    this.followersCount = 0,
    this.followingCount = 0,
    this.coins = 0,
    this.activeAuctionsCount = 0,
    this.followedByAccountsIds = const [],
    this.followingAccountsIds = const [],
    this.filters = const [],
    this.allowedNotifications,
    this.reviewsAverage,
    this.reviewsCount = 0,
    this.categoriesSetupDone = false,
    this.preferredCategoriesIds = const [],
    this.verified = false,
    this.verifiedAt,
    this.verificationRequestedAt,
    this.meta,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.aiResponsesCount,
  });

  static Account fromJSON(dynamic data) {
    var serverBaseUrl = FlutterConfig.get('SERVER_URL');
    var picture =
        data['asset'] != null ? Asset.fromJSON(data['asset']) : data['picture'];

    var locationLat = data['locationLat'];
    var locationLong = data['locationLong'];
    var locationLatLng = locationLat != null && locationLong != null
        ? LatLng(locationLat, locationLong)
        : null;

    return Account(
      id: data['id'],
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      isAnonymous: data['isAnonymous'] ?? false,
      picture: picture is String
          ? picture
          : (picture.id != null
                  ? '$serverBaseUrl/assets/${picture.path}'
                  : picture) ??
              '',
      aiResponsesCount: data['aiResponsesCount'] != null
          ? int.parse(data['aiResponsesCount'].toString())
          : 0,
      reviewsAverage: data['reviewsAverage'] != null
          ? double.parse(data['reviewsAverage'].toString())
          : null,
      reviewsCount: data['reviewsCount'] != null
          ? int.parse(data['reviewsCount'].toString())
          : 0,
      categoriesSetupDone: data['categoriesSetupDone'] ?? false,
      preferredCategoriesIds: data['preferredCategoriesIds'] != null
          ? List<String>.from(data['preferredCategoriesIds'])
          : [],
      locationLatLng: locationLatLng,
      phone: data['phone'] ?? '',
      locationPretty: data['locationPretty'],
      selectedCurrencyId: data['selectedCurrencyId'],
      coins: data['coins'] ?? 0,
      deviceFCMToken: data['deviceFCMToken'] ?? '',
      followersCount: data['followersCount'] ?? 0,
      followingCount: data['followingCount'] ?? 0,
      introDone: data['introDone'] ?? false,
      introSkipped: data['introSkipped'] ?? false,
      acceptedTermsAndCondition: data['acceptedTermsAndCondition'] ?? false,
      meta: data['meta'] != null
          ? AccountMetadata.fromJSON(data['meta'])
          : AccountMetadata(),
      activeAuctionsCount: data['activeAuctionsCount'] != null
          ? int.tryParse(data['activeAuctionsCount'].toString())
          : 0,
      blockedAccounts: data['blockedAccounts'] != null
          ? List<String>.from(data['blockedAccounts'])
          : [],
      followedByAccountsIds: data['followedByAccountsIds'] != null
          ? List<String>.from(data['followedByAccountsIds'])
          : [],
      followingAccountsIds: data['followingAccountsIds'] != null
          ? List<String>.from(data['followingAccountsIds'])
          : [],
      auctions: data['auctions'] != null
          ? data['auctions'].map<Auction>((el) => Auction.fromJSON(el)).toList()
          : [],
      reviews: data['receivedReviews'] != null
          ? data['receivedReviews']
              .map<Review>((el) => Review.fromJSON(el))
              .toList()
          : [],
      filters: data['filters'] != null
          ? data['filters']
              .map<FilterItem>((el) => FilterItem.fromJSON(el))
              .toList()
          : [],
      allowedNotifications: data['allowedNotifications'] != null
          ? AccountNotifications.fromJSON(data['allowedNotifications'])
          : AccountNotifications(),
      verified: data['verified'] ?? false,
      verifiedAt: data['verifiedAt'] != null
          ? DateTime.parse(data['verifiedAt'])
          : null,
      verificationRequestedAt: data['verificationRequestedAt'] != null
          ? DateTime.parse(data['verificationRequestedAt'])
          : null,
      createdAt:
          data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      updatedAt:
          data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }

  Map toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'picture': picture,
      };
}

class AccountNotifications {
  bool NEW_BID_ON_AUCTION;
  bool AUCTION_UPDATED;
  bool BID_REMOVED_ON_AUCTION;
  bool BID_ACCEPTED_ON_AUCTION;
  bool BID_REJECTED_ON_AUCTION;
  bool REVIEW_RECEIVED;
  bool NEW_MESSAGE;
  bool SYSTEM;
  bool SOMEONE_ELSE_ADDED_BID_TO_SAME_AUCTION;
  bool BID_WAS_SEEN;
  bool NEW_FOLLOWER;
  bool AUCTION_FROM_FAVOURITES_HAS_BID;
  bool NEW_AUCTION_FROM_FOLLOWING;
  bool AUCTION_ADDED_TO_FAVOURITES;
  bool FAVOURITE_AUCTION_PRICE_CHANGE;
  bool MY_AUCTION_STARTED;
  bool AUCTION_FROM_FAVOURITES_STARTED;
  bool COMMENT_ON_SAME_AUCTION;
  bool REPLY_ON_AUCTION_COMMENT;
  bool NEW_COMMENT_ON_AUCTION;

  AccountNotifications({
    this.NEW_BID_ON_AUCTION = true,
    this.AUCTION_UPDATED = true,
    this.BID_REMOVED_ON_AUCTION = true,
    this.BID_ACCEPTED_ON_AUCTION = true,
    this.BID_REJECTED_ON_AUCTION = true,
    this.REVIEW_RECEIVED = true,
    this.NEW_MESSAGE = true,
    this.SYSTEM = true,
    this.SOMEONE_ELSE_ADDED_BID_TO_SAME_AUCTION = true,
    this.BID_WAS_SEEN = true,
    this.NEW_FOLLOWER = true,
    this.AUCTION_FROM_FAVOURITES_HAS_BID = true,
    this.NEW_AUCTION_FROM_FOLLOWING = true,
    this.AUCTION_ADDED_TO_FAVOURITES = true,
    this.FAVOURITE_AUCTION_PRICE_CHANGE = true,
    this.MY_AUCTION_STARTED = true,
    this.AUCTION_FROM_FAVOURITES_STARTED = true,
    this.COMMENT_ON_SAME_AUCTION = true,
    this.REPLY_ON_AUCTION_COMMENT = true,
    this.NEW_COMMENT_ON_AUCTION = true,
  });

  static AccountNotifications fromJSON(dynamic data) {
    return AccountNotifications(
      NEW_BID_ON_AUCTION:
          AccountNotifications.parseBool(data['NEW_BID_ON_AUCTION']),
      AUCTION_UPDATED: AccountNotifications.parseBool(data['AUCTION_UPDATED']),
      BID_REMOVED_ON_AUCTION:
          AccountNotifications.parseBool(data['BID_REMOVED_ON_AUCTION']),
      BID_ACCEPTED_ON_AUCTION:
          AccountNotifications.parseBool(data['BID_ACCEPTED_ON_AUCTION']),
      BID_REJECTED_ON_AUCTION:
          AccountNotifications.parseBool(data['BID_REJECTED_ON_AUCTION']),
      REVIEW_RECEIVED: AccountNotifications.parseBool(data['REVIEW_RECEIVED']),
      NEW_MESSAGE: AccountNotifications.parseBool(data['NEW_MESSAGE']),
      SYSTEM: AccountNotifications.parseBool(data['SYSTEM']),
      SOMEONE_ELSE_ADDED_BID_TO_SAME_AUCTION: AccountNotifications.parseBool(
          data['SOMEONE_ELSE_ADDED_BID_TO_SAME_AUCTION']),
      BID_WAS_SEEN: AccountNotifications.parseBool(data['BID_WAS_SEEN']),
      NEW_FOLLOWER: AccountNotifications.parseBool(data['NEW_FOLLOWER']),
      AUCTION_FROM_FAVOURITES_HAS_BID: AccountNotifications.parseBool(
          data['AUCTION_FROM_FAVOURITES_HAS_BID']),
      NEW_AUCTION_FROM_FOLLOWING:
          AccountNotifications.parseBool(data['NEW_AUCTION_FROM_FOLLOWING']),
      AUCTION_ADDED_TO_FAVOURITES:
          AccountNotifications.parseBool(data['AUCTION_ADDED_TO_FAVOURITES']),
      FAVOURITE_AUCTION_PRICE_CHANGE: AccountNotifications.parseBool(
          data['FAVOURITE_AUCTION_PRICE_CHANGE']),
      MY_AUCTION_STARTED:
          AccountNotifications.parseBool(data['MY_AUCTION_STARTED']),
      AUCTION_FROM_FAVOURITES_STARTED: AccountNotifications.parseBool(
          data['AUCTION_FROM_FAVOURITES_STARTED']),
      COMMENT_ON_SAME_AUCTION:
          AccountNotifications.parseBool(data['COMMENT_ON_SAME_AUCTION']),
      REPLY_ON_AUCTION_COMMENT:
          AccountNotifications.parseBool(data['REPLY_ON_AUCTION_COMMENT']),
      NEW_COMMENT_ON_AUCTION:
          AccountNotifications.parseBool(data['NEW_COMMENT_ON_AUCTION']),
    );
  }

  Object asObject() {
    return {
      'NEW_BID_ON_AUCTION': NEW_BID_ON_AUCTION,
      'AUCTION_UPDATED': AUCTION_UPDATED,
      'BID_REMOVED_ON_AUCTION': BID_REMOVED_ON_AUCTION,
      'BID_ACCEPTED_ON_AUCTION': BID_ACCEPTED_ON_AUCTION,
      'BID_REJECTED_ON_AUCTION': BID_REJECTED_ON_AUCTION,
      'REVIEW_RECEIVED': REVIEW_RECEIVED,
      'NEW_MESSAGE': NEW_MESSAGE,
      'SYSTEM': SYSTEM,
      'SOMEONE_ELSE_ADDED_BID_TO_SAME_AUCTION':
          SOMEONE_ELSE_ADDED_BID_TO_SAME_AUCTION,
      'BID_WAS_SEEN': BID_WAS_SEEN,
      'NEW_FOLLOWER': NEW_FOLLOWER,
      'AUCTION_FROM_FAVOURITES_HAS_BID': AUCTION_FROM_FAVOURITES_HAS_BID,
      'NEW_AUCTION_FROM_FOLLOWING': NEW_AUCTION_FROM_FOLLOWING,
      'AUCTION_ADDED_TO_FAVOURITES': AUCTION_ADDED_TO_FAVOURITES,
      'FAVOURITE_AUCTION_PRICE_CHANGE': FAVOURITE_AUCTION_PRICE_CHANGE,
      'MY_AUCTION_STARTED': MY_AUCTION_STARTED,
      'AUCTION_FROM_FAVOURITES_STARTED': AUCTION_FROM_FAVOURITES_STARTED,
    };
  }

  static bool parseBool(dynamic value, {bool defaultValue = true}) {
    if (value is bool) {
      // If the value is already a bool, return it.
      return value;
    } else if (value is String) {
      // Convert string to lowercase to handle case variations.
      final lowerValue = value.toLowerCase();
      if (lowerValue == 'true') {
        return true;
      } else if (lowerValue == 'false') {
        return false;
      }
    }
    // If conversion is not possible, return the default value.
    return defaultValue;
  }
}

class AccountMetadata {
  DateTime? lastSignInTime;
  String? appLanguage;

  AccountMetadata({
    this.lastSignInTime,
    this.appLanguage,
  });

  static AccountMetadata fromJSON(dynamic data) {
    try {
      var lastSignInTime = data['lastSignInTime'] != null
          ? DateTime.parse(data['lastSignInTime'])
          : null;
      return AccountMetadata(
        lastSignInTime: lastSignInTime,
        appLanguage: data['appLanguage'],
      );
    } catch (e) {
      return AccountMetadata(appLanguage: data['appLanguage']);
    }
  }

  Object asObject() {
    return {
      'lastSignInTime': lastSignInTime,
      'appLanguage': appLanguage,
    };
  }
}
