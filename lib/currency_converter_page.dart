import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phonecodes/phonecodes.dart';
import 'package:currency_converter_pro/currency_converter_pro.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SpeedyQrPage extends StatefulWidget {
  const SpeedyQrPage({super.key});

  @override
  State<SpeedyQrPage> createState() => _SpeedyQrCupertinoPageState();
}

class _SpeedyQrCupertinoPageState extends State<SpeedyQrPage> {
  final TextEditingController _myController = TextEditingController();
  final List<Country> _list = Country.values;

  String toSymbol = Country.unitedStates.currency.symbol;
  String toFlag = Country.unitedStates.flag;
  String fromFlag = Country.unitedStates.flag;
  String fromSymbol = Country.unitedStates.currency.symbol;
  int _adsCounter = 0;
  List<int> _listOfAds = [
    35,
    60,
    85,
    105,
    130,
    155,
    180,
    205,
    230,
    255,
    280,
    300,
    325,
    350,
    375,
    400,
    425,
    450,
    475,
    500
  ];

  String _convertedAmount = '0.0';
  String fromCurrency = Country.unitedStates.currency.code.toLowerCase();
  String toCurrency = Country.unitedStates.currency.code.toLowerCase();

  Future<void> _convertCurrency() async {
    final double amount = double.tryParse(_myController.text) ?? 0;
    try {
      final result = await CurrencyConverterPro().convertCurrency(
        amount: amount,
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
      );
      _adsCounter += 5;

      if (_adsCounter == 10) {
        Future.delayed(
          Duration(seconds: 1),
          () {
            UnityAds.load(
              placementId: "Interstitial_Android",
              onComplete: (placementId) {
                UnityAds.showVideoAd(placementId: placementId);
              },
            );
          },
        );
      } else if (_listOfAds.contains(_adsCounter)) {
        Future.delayed(
          Duration(seconds: 1),
          () {
            UnityAds.load(
              placementId: "Rewarded_Android",
              onComplete: (placementId) {
                UnityAds.showVideoAd(placementId: placementId);
              },
            );
          },
        );
      }
      setState(() {
        _convertedAmount = result.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _convertedAmount = 'Error: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    UnityAds.init(
      gameId: defaultTargetPlatform == TargetPlatform.android
          ? "${dotenv.env["android_ads_code"]}"
          : '${dotenv.env["ios_ads_code"]}',
      onComplete: () {
        UnityAds.load(
          placementId: 'Rewarded_Android',
        );
        UnityAds.load(
          placementId: 'Interstitial_Android',
        );
        UnityAds.load(
          placementId: 'Banner_Android',
        );
      },
      onFailed: (error, message) =>
          print('Initialization Failed: $error $message'),
    );
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic inputBorderFn(double value) {
      return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white70, width: value),
        borderRadius: BorderRadius.circular(30.0),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFACFFB4),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Color(0xFF78E992),
          elevation: 10.0,
          centerTitle: true,
          title: const Text(
            "Speedy Currency Converter",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 3.0,
                  )
                ]),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/app_home_logo.png"),
              height: 200.0,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    toFlag,
                    style: TextStyle(
                        fontSize: _convertedAmount.length < 8 ? 40.0 : 25.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '$_convertedAmount $toSymbol',
                      style: TextStyle(
                        fontSize: _convertedAmount.length < 8 ? 40.0 : 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff01161e),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _myController,
                maxLength: 10,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                cursorColor: Colors.pink,
                decoration: InputDecoration(
                  hintText: "Please enter the amount",
                  hintStyle: TextStyle(color: const Color(0xB3979797)),
                  prefixText: fromFlag + " " + fromSymbol + " ",
                  prefixStyle: TextStyle(
                      color: Colors.pink,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: Colors.white30,
                  focusedBorder: inputBorderFn(2.0),
                  enabledBorder: inputBorderFn(1.0),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            DropdownButton<String>(
              onChanged: (String? value) {},
              value: fromFlag,
              items: _list.map(
                (Country value) {
                  return DropdownMenuItem<String>(
                    value: value.flag,
                    onTap: () {
                      setState(
                        () {
                          fromFlag = value.flag;
                          fromSymbol = value.currency.symbol;
                          fromCurrency = value.currency.code.toLowerCase();
                          _convertCurrency();
                        },
                      );
                    },
                    child: Text("${value.flag} ${value.name}"),
                  );
                },
              ).toList(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 30,
                color: Colors.white,
              ),
            ),
            Image(
              image: AssetImage("assets/gifs/exchange-unscreen.gif"),
              height: 60.0,
            ),
            DropdownButton<String>(
              onChanged: (String? value) {},
              value: toFlag,
              items: _list.map(
                (Country value) {
                  return DropdownMenuItem<String>(
                    onTap: () {
                      setState(() {
                        toSymbol = value.currency.symbol;
                        toFlag = value.flag;
                        toCurrency = value.currency.code.toLowerCase();
                        _convertCurrency();
                      });
                    },
                    value: value.flag,
                    child: Text("${value.flag} ${value.name}"),
                  );
                },
              ).toList(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 30,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  _convertCurrency();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.pink,
                  minimumSize: const Size(double.infinity, 50.0),
                ),
                child: Text(
                  "Convert",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UnityBannerAd(
        placementId: "Banner_Android",
      ),
    );
  }
}
