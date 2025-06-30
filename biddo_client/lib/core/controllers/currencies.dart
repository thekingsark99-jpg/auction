import 'dart:async';

import 'package:biddo/core/repositories/main.dart';
import 'package:get/get.dart';

import '../models/account.dart';
import '../models/auction.dart';
import '../models/currency.dart';
import '../models/exchange_rate.dart';
import '../models/settings.dart';
import 'account.dart';
import 'settings.dart';

class CurrenciesController extends GetxController {
  final mainRepository = Get.find<MainRepository>();
  final accountController = Get.find<AccountController>();
  final settingsController = Get.find<SettingsController>();

  RxList<Currency> currencies = RxList<Currency>();
  Rx<ExchangeRate?> exchangeRate = Rx<ExchangeRate?>(null);
  Rx<Currency?> selectedCurrency = Rx<Currency?>(null);

  late StreamSubscription<Account?> _accountSubscription;
  late StreamSubscription<BiddoSettings?> _settingsSubscription;

  @override
  void onInit() {
    super.onInit();

    _accountSubscription = accountController.account.listen((value) {
      if (value.selectedCurrencyId == null) {
        return;
      }

      selectedCurrency.value = currencies.firstWhereOrNull(
        (currency) => currency.id == value.selectedCurrencyId,
      );
    });

    _settingsSubscription = settingsController.settings.listen((value) {
      if (selectedCurrency.value?.id != null) {
        return;
      }

      if (accountController.account.value.selectedCurrencyId != null) {
        return;
      }

      if (value.defaultCurrencyId == null) {
        return;
      }

      selectedCurrency.value = currencies.firstWhereOrNull(
        (currency) => currency.id == value.defaultCurrencyId,
      );
    });
  }

  @override
  void onClose() {
    super.onClose();
    _accountSubscription.cancel();
    _settingsSubscription.cancel();
  }

  Future<void> load() async {
    currencies.value = await mainRepository.fetchCurrencies();
    exchangeRate.value = await mainRepository.fetchExchangeRate(currencies);
  }

  void updateExchangeRate(dynamic data) {
    try {
      var parsedData = ExchangeRate.fromJSON(data, currencies);
      exchangeRate.value = parsedData;
    } catch (error) {
      print('Could not update exchange rate $error');
    }
  }

  num convertPrice(num price, String? fromCurrencyId) {
    String targetCurrencyCode = selectedCurrency.value?.code ?? 'USD';
    if (fromCurrencyId == null || fromCurrencyId == '') {
      return price;
    }

    var fromCurrency = currencies.firstWhereOrNull(
      (currency) => currency.id == fromCurrencyId,
    );

    if (fromCurrency == null) {
      return price;
    }

    var fromCurrencyCode = fromCurrency.code;
    if (fromCurrencyCode == targetCurrencyCode) {
      return price;
    }

    double fromRate = exchangeRate.value!.rates[fromCurrencyCode] ?? 1.0;
    double toRate = exchangeRate.value!.rates[targetCurrencyCode] ?? 1.0;

    return price / fromRate * toRate;
  }

  AuctionMaxPriceResult getMaxPriceFromAuctionBids(Auction auction) {
    var auctionDefaultCurrencyId = auction.initialCurrencyId ??
        settingsController.settings.value.defaultCurrencyId ??
        currencies.first.id;

    if (exchangeRate.value == null || selectedCurrency.value == null) {
      return AuctionMaxPriceResult(
        maxPrice: auction.startingPrice,
        currencyId: auctionDefaultCurrencyId,
      );
    }

    AuctionMaxPriceResult maxPrice;

    if (auction.bids.isNotEmpty) {
      var maxPriceValue = auction.bids
          .map((bid) =>
              convertPrice(bid.value.price ?? 0, bid.value.initialCurrencyId))
          .reduce((a, b) => a > b ? a : b);

      var bidWithMaxValue = auction.bids.firstWhere(
        (bid) =>
            convertPrice(bid.value.price ?? 0, bid.value.initialCurrencyId) ==
            maxPriceValue,
      );

      maxPrice = AuctionMaxPriceResult(
        maxPrice: maxPriceValue,
        currencyId:
            bidWithMaxValue.value.initialCurrencyId ?? auctionDefaultCurrencyId,
      );
    } else {
      maxPrice = AuctionMaxPriceResult(
          maxPrice:
              convertPrice(auction.startingPrice, auctionDefaultCurrencyId),
          currencyId: auctionDefaultCurrencyId);
    }

    return maxPrice;
  }
}

class AuctionMaxPriceResult {
  final num maxPrice;
  final String currencyId;

  AuctionMaxPriceResult({
    required this.maxPrice,
    required this.currencyId,
  });
}
