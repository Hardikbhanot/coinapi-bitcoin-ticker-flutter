import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  // late double rate;

  late String BTCvalue = '';
  late String ETHvalue = '';
  late String LTCvalue = '';

  void getData(String currency) async {
    try {
      double data1 = await CoinData().getCoinData(currency, cryptoList[0]);
      double data2 = await CoinData().getCoinData(currency, cryptoList[1]);
      double data3 = await CoinData().getCoinData(currency, cryptoList[2]);
      setState(() {
        BTCvalue = data1.toStringAsFixed(0);
        ETHvalue = data2.toStringAsFixed(0);
        LTCvalue = data3.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
    getData('USD');
    // BTCtoUSD =rate.toStringAsFixed(1);
  }

  List<DropdownMenuItem<String>> getDropDownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      var newItem = DropdownMenuItem(
        child: Text(currenciesList[i]),
        value: currenciesList[i],
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  DropdownButton<String> getDropDownButton() {
    return DropdownButton<String>(
        value: selectedCurrency,
        items: getDropDownItems(),
        onChanged: (value) {
          setState(() {
            selectedCurrency = value!;
            getData(selectedCurrency);
          });
        });
  }

       
     

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            selectedCurrency = currenciesList[selectedIndex];
            getData(selectedCurrency);
          });
        },
        children: getCupertinoItems());
  }

  List<Text> getCupertinoItems() {
    List<Text> CupertinoItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      var newItem = Text(currenciesList[i]);
      CupertinoItems.add(newItem);
    }
    return CupertinoItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
           CryptoCard(cryptoName: 'BTC', value: BTCvalue, selectedCurrency: selectedCurrency),
           CryptoCard(cryptoName: 'ETH', value: ETHvalue, selectedCurrency: selectedCurrency),
           CryptoCard(cryptoName: 'LTC', value: LTCvalue, selectedCurrency: selectedCurrency),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iOSPicker() : getDropDownButton())
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    Key? key,
    required this.cryptoName,
    required this.value,
    required this.selectedCurrency,
  }) : super(key: key);

  final String cryptoName;
  final String value;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoName = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
