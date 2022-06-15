import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const List<String> kCurrenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> kCryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  final String _url = 'https://rest.coinapi.io/v1/exchangerate';
  final Map<String, String> _header = {
    'X-CoinAPI-Key': 'AF2B054A-3861-415C-9005-C372E8D57B91'
  };

  final HashMap<String, HashMap<String, double>> _rates = HashMap();

  Future<double> getRate(String crypto, String currency) async {
    if ((!_rates.containsKey(crypto)) || (!_rates[crypto]!.containsKey(currency))) {
      await _getData(crypto, currency);
    }
    return _rates[crypto]![currency]!;
  }

  Future<void> _getData(String crypto, String currency) async {
    final response = await http.get(
      Uri.parse('$_url/$crypto/$currency'),
      headers: _header,
    );
    if (response.statusCode != 200) {
      if (kDebugMode) {
        print(response.statusCode);
      }
      return;
    }
    var data = jsonDecode(response.body);
    double rate = data['rate'];
    HashMap<String, double> quote = HashMap();
    quote.addAll({currency : rate});
    if (!_rates.containsKey(crypto)) {
      _rates.addAll({data['asset_id_base']: quote});
    } else {
      if (!_rates[crypto]!.containsKey(currency)) {
        _rates[crypto]?.addAll(quote);
      }
    }
  }
}
