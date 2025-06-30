import '../../utils/constants.dart';

class Currency {
  String id;
  String code;
  String symbol;
  Map<String, String> name;

  Currency({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
  });

  static Currency fromJSON(dynamic data) {
    return Currency(
      id: data['id'],
      code: data['code'],
      name: Map.fromEntries(
        Constants.LANGUAGES.map((lang) => MapEntry(
              lang['code']!,
              data['name'][lang['code']] ?? '',
            )),
      ),
      symbol: data['symbol'],
    );
  }
}
