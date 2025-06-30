import 'package:get/get.dart';
import '../models/currency.dart';
import '../models/exchange_rate.dart';
import 'base.dart';

class MainRepository {
  var dio = Get.find<Api>();

  RxList<Currency> currencies = RxList<Currency>();
  Rx<ExchangeRate?> exchangeRate = Rx<ExchangeRate?>(null);

  Future<bool> serverIsRunning() async {
    try {
      await dio.api.get('/');
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<Currency>> fetchCurrencies() async {
    try {
      var response = await dio.api.get('/currency');
      var list = List<Currency>.from(
        response.data.map(
          (e) => Currency.fromJSON(e),
        ),
      );
      list.sort((a, b) => a.code.compareTo(b.code));
      return list;
    } catch (error) {
      print('Error fetching currencies: $error');
      return [];
    }
  }

  Future<ExchangeRate?> fetchExchangeRate(List<Currency> currencies) async {
    try {
      var response = await dio.api.get('/exchange-rate');
      return ExchangeRate.fromJSON(response.data, currencies);
    } catch (error) {
      print('Error fetching exchange rate: $error');
      return null;
    }
  }

  Future<bool> sendUsAMessage(String message) async {
    try {
      await dio.api.post('/user-message', data: {
        'message': message,
      });
      return true;
    } catch (error) {
      return false;
    }
  }
}
