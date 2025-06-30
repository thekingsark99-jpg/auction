import 'currency.dart';

class ExchangeRate {
  String id;
  String baseCurrencyId;
  Map<String, double> rates;

  ExchangeRate({
    required this.id,
    required this.baseCurrencyId,
    required this.rates,
  });

  static ExchangeRate fromJSON(dynamic data, List<Currency> currencies) {
    return ExchangeRate(
      id: data['id'],
      baseCurrencyId: data['baseCurrencyId'],
      rates: Map.fromEntries(
        currencies.map((currency) => MapEntry(
              currency.code,
              double.parse((data['rates'][currency.code] ?? 1.0).toString()),
            )),
      ),
    );
  }
}
