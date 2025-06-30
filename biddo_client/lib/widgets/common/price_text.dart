import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/currencies.dart';
import '../../core/controllers/settings.dart';
import '../../theme/extensions/base.dart';

class PriceText extends StatelessWidget {
  final num price;
  final String? initialCurrencyId;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? initialCurrencyIsSameAsTargetCurrency;

  final currenciesController = Get.find<CurrenciesController>();
  final settingsController = Get.find<SettingsController>();

  PriceText({
    required this.price,
    this.style,
    this.maxLines,
    this.overflow,
    this.initialCurrencyId,
    this.textAlign,
    this.initialCurrencyIsSameAsTargetCurrency = false,
  });

  @override
  Widget build(BuildContext context) {
    var locale = Localizations.localeOf(context).languageCode;

    return Obx(() {
      final exchangeRate = currenciesController.exchangeRate.value;
      final selectedCurrency = currenciesController.selectedCurrency.value;

      // ignore: unnecessary_null_comparison
      if (exchangeRate == null || selectedCurrency == null) {
        // If no exchange rates or selected currency, return the price in default format
        return Text(
          NumberFormat.currency(
            decimalDigits: price % 1 == 0 ? 0 : 2,
            locale: locale,
            symbol: '\$', // Default symbol if no currency is selected
          ).format(price),
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
          style: style ??
              Theme.of(context).extension<CustomThemeFields>()!.smaller,
        );
      }

      String baseCurrencyId =
          settingsController.settings.value.defaultCurrencyId ??
              exchangeRate.baseCurrencyId;
      String fromCurrencyId = initialCurrencyId ?? baseCurrencyId;
      String toCurrencyCode = selectedCurrency.code;

      // Get exchange rates
      var fromCurrency = currenciesController.currencies.firstWhereOrNull(
        (currency) => currency.id == fromCurrencyId,
      );

      if (fromCurrency == null) {
        return Text(
          NumberFormat.currency(
            decimalDigits: price % 1 == 0 ? 0 : 2,
            locale: locale,
            symbol: '\$', // Default symbol if no currency is selected
          ).format(price),
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
          style: style ??
              Theme.of(context).extension<CustomThemeFields>()!.smaller,
        );
      }

      var rateCode = (initialCurrencyIsSameAsTargetCurrency ?? false)
          ? toCurrencyCode
          : fromCurrency.code;

      double fromRate = exchangeRate.rates[rateCode] ?? 1.0;
      double toRate = exchangeRate.rates[toCurrencyCode] ?? 1.0;

      // Convert price
      double convertedPrice = price / fromRate * toRate;

      return Text(
        NumberFormat.currency(
          decimalDigits: convertedPrice % 1 == 0 ? 0 : 2,
          locale: locale,
          symbol: selectedCurrency.symbol,
        ).format(convertedPrice),
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
        style:
            style ?? Theme.of(context).extension<CustomThemeFields>()!.smaller,
      );
    });
  }
}
