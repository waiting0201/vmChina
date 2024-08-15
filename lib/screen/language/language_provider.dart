import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/models.dart';
import '../../model/repository.dart';
//import '../../generated/l10n.dart';
//import '../widgets/library.dart';

class LanguageChangeProvider with ChangeNotifier {
  late Locale _currentLocale;
  late String _currentLanguage;
  late String _currentCurrency;
  late String _currsymbol;
  late double _exchange;
  late bool _status = false;

  Locale get currentLocale => _currentLocale;
  String get currentLanguage => _currentLanguage;
  String get currentCurrency => _currentCurrency;
  String get currsymbol => _currsymbol;
  double get exchange => _exchange;
  bool get status => _status;

  LanguageChangeProvider() {
    Locale xlocale = const Locale.fromSubtags(
      languageCode: "zh",
      scriptCode: "Hans",
      countryCode: "CN",
    );

    debugPrint("lang provider : $xlocale");
    /*xlocale = setDefaultLocale(xlocale, S.delegate.supportedLocales);
    log("p - t : $xlocale");*/

    _currentLocale = xlocale;
    /*_currentLanguage = "${xlocale.languageCode}-${xlocale.countryCode}";

    if (xlocale.languageCode == "zh") {
      if (xlocale.countryCode == "CN") {
        _currentCurrency = "CNY";
      } else {
        _currentCurrency = "EUR";
      }
    } else {
      _currentCurrency = "EUR";
    }

    setRegion(_currentCurrency, _currentLanguage);
    defaultlanguage();
    defaultcurrency();*/
  }

  Future<void> setRegion(String curr, String code) async {
    debugPrint("lang provider setRegion curr: $curr lang: $code");

    SharedPreferences pres = await SharedPreferences.getInstance();

    HttpService httpService = HttpService();
    await httpService.getlanguagebycurrandcodeasync(curr, code).then(
      (value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200) {
          Language language = Language.fromMap(data["data"]);
          debugPrint("languageid : ${language.langid}");
          debugPrint(language.currsymbol);

          pres.setString("languageid", language.langid);
          pres.setString("currsymbol", language.currsymbol);
          pres.setDouble("exchange", language.exchange);

          _currsymbol = language.currsymbol;
          _exchange = language.exchange;
          _status = true;

          notifyListeners();
        } else {
          debugPrint("setRegion: ${data["statusCode"]}");
        }
      },
    );
  }

  Future<void> iniRegion(String curr, String code) async {
    debugPrint("lang provider iniRegion curr: $curr lang: $code");

    SharedPreferences pres = await SharedPreferences.getInstance();

    pres.setString("languageid", "67f14945-6988-48a4-8f29-17971416f0ee");
    pres.setString("currsymbol", "¥");
    pres.setDouble("exchange", 8);

    _currsymbol = "¥";
    _exchange = 8;
    _status = true;

    notifyListeners();
  }

  Future<void> defaultlanguage() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    _currentLanguage = pres.getString("language_code") ?? _currentLanguage;

    debugPrint("defaultlanguage: $currentLanguage");

    if (_currentLanguage.isNotEmpty) {
      await changeLocale(_currentLanguage);
    }
  }

  Future<void> changeLocale(String language) async {
    SharedPreferences pres = await SharedPreferences.getInstance();

    if (language == "zh-CN") {
      _currentLocale = const Locale.fromSubtags(
        languageCode: "zh",
        scriptCode: "Hans",
        countryCode: "CN",
      );
      /*} else if (language == "zh-TW") {
      _currentLocale = const Locale.fromSubtags(
        languageCode: "zh",
        scriptCode: "Hant",
        countryCode: "TW",
      );
    } else if (language == "zh-HK") {
      _currentLocale = const Locale.fromSubtags(
        languageCode: "zh",
        scriptCode: "Hant",
        countryCode: "HK",
      );
    } else if (language == "ja-JP") {
      _currentLocale = const Locale.fromSubtags(
        languageCode: "ja",
        countryCode: "JP",
      );
    } else if (language == "ko-KR") {
      _currentLocale = const Locale.fromSubtags(
        languageCode: "ko",
        countryCode: "KR",
      );*/
    } else {
      _currentLocale = Locale(language);
    }

    _currentLanguage = language;

    pres.setString("language_code", language);

    notifyListeners();
  }

  Future<void> defaultcurrency() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    _currentCurrency = pres.getString("currency_title") ?? currentCurrency;

    debugPrint("defaultcurrency: $_currentCurrency");

    if (_currentCurrency.isNotEmpty) {
      await changeCurrency(_currentCurrency);
    }
  }

  Future<void> changeCurrency(String currency) async {
    SharedPreferences pres = await SharedPreferences.getInstance();

    _currentCurrency = currency;

    pres.setString("currency_title", currency);

    notifyListeners();
  }
}
