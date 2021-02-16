import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedItem = 'USD';
  String bitcoinValue = '';
  String ethValue = '';
  String ltcValue = '';
  String bitcoinPair = '';
  String ethPair = '';
  String ltcPair = '';
  @override
  void initState() {
    super.initState();
    updateUI();
  }

  updateUI() {
    bitcoinPair = 'BTC$selectedItem';
    ethPair = 'ETH$selectedItem';
    ltcPair = 'LTC$selectedItem';
    getBitcoinData();
    getEthData();
    getLtcData();
  }

  void getBitcoinData() async {
    try {
      double data = await CoinData().getCoinData(bitcoinPair);
      setState(() {
        bitcoinValue = data.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  void getEthData() async {
    try {
      double data = await CoinData().getCoinData(ethPair);
      setState(() {
        ethValue = data.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  void getLtcData() async {
    try {
      double data = await CoinData().getCoinData(ltcPair);
      setState(() {
        ltcValue = data.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem<String>> listItems = [];
    for (String item in currenciesList) {
      var newItem = DropdownMenuItem(
        value: item,
        child: Text(item),
      );
      listItems.add(newItem);
    }
    return DropdownButton<String>(
        icon: Icon(Icons.attach_money),
        value: selectedItem,
        items: listItems,
        onChanged: (value) {
          setState(() {
            selectedItem = value;
            updateUI();
          });
        });
  }

  CupertinoPicker getCupertinoPicker() {
    List<Text> pickerItems = [];
    for (String item in currenciesList) {
      pickerItems.add(Text(
        item,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ));
    }
    return CupertinoPicker(
      magnification: 1.0,
      useMagnifier: true,
      backgroundColor: Colors.lightBlue,
      itemExtent: 30.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedItem = currenciesList[selectedIndex];
          updateUI();
        });
      },
      children: pickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.attach_money),
        title: Text(' Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PriceCard(
              coinValue: bitcoinValue,
              coinType: 'BTC',
              selectedItem: selectedItem),
          PriceCard(
              coinValue: ethValue, coinType: 'ETH', selectedItem: selectedItem),
          PriceCard(
              coinValue: ltcValue, coinType: 'LTC', selectedItem: selectedItem),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getCupertinoPicker() : getDropdownButton(),
          ),
        ],
      ),
    );
  }
}

class PriceCard extends StatelessWidget {
  const PriceCard({this.coinValue, this.coinType, this.selectedItem});

  final String coinValue;
  final String coinType;
  final String selectedItem;

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
            '1 $coinType = $coinValue   $selectedItem',
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
