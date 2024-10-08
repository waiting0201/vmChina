import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../model/models.dart';
import '../../model/repository.dart';

class SetupChangeProvider with ChangeNotifier {
  late bool _isLoading = false;
  late Setup _setup;

  Setup get setup => _setup;
  bool get isloading => _isLoading;

  SetupChangeProvider() {
    getsetup();
  }

  Future<void> setLoading(bool value) async {
    _isLoading = value;
    notifyListeners();
    log(_isLoading.toString());
  }

  Future<void> setSetup(dynamic value) async {
    _setup = Setup.fromMap(value);
    notifyListeners();
  }

  Future<void> getsetup() async {
    try {
      await setLoading(true);
      HttpService httpService = HttpService();
      Response response = await httpService.getsetup();
      var data = json.decode(response.toString());
      if (data["statusCode"] == 200) {
        await setSetup(data["data"]);
        await setLoading(false);
      } else {
        await setLoading(false);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
