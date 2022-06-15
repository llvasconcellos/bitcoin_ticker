import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _selectedCurrency = 'USD';
  late CoinData _coinData;
  double _BTCRate = 0;
  double _ETHRate = 0;
  double _LTCRate = 0;

  Widget getPicker() {
    if (Platform.isIOS) {
      return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32,
        onSelectedItemChanged: (index) {
          _getData(kCurrenciesList[index]);
        },
        children: <Widget>[
          for (var item in kCurrenciesList) Text(item),
        ],
      );
    } else {
      return DropdownButton<String>(
        value: _selectedCurrency,
        onChanged: (value) {
          _getData(value!);
        },
        items: <DropdownMenuItem<String>>[
          for (var item in kCurrenciesList)
            DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _coinData = CoinData();
    _getData(_selectedCurrency);
  }

  void _getData(String currency) async {
    double btcRate = await _coinData.getRate('BTC', currency);
    double ethRate = await _coinData.getRate('ETH', currency);
    double ltcRate = await _coinData.getRate('LTC', currency);
    setState(() {
      _selectedCurrency = currency;
      _BTCRate = btcRate;
      _ETHRate = ethRate;
      _LTCRate = ltcRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ExchangeRate(
            crypto: 'BTC',
            currency: _selectedCurrency,
            rate: _BTCRate,
          ),
          ExchangeRate(
            crypto: 'ETH',
            currency: _selectedCurrency,
            rate: _ETHRate,
          ),
          ExchangeRate(
            crypto: 'LTC',
            currency: _selectedCurrency,
            rate: _LTCRate,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

class ExchangeRate extends StatelessWidget {
  final String currency;
  final String crypto;
  final double rate;

  const ExchangeRate(
      {Key? key,
      required this.currency,
      required this.crypto,
      required this.rate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = ${rate.toStringAsFixed(2)} $currency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
