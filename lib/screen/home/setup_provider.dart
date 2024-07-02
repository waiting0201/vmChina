import 'dart:convert';

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

  Future<void> getsetup() async {
    if (!_isLoading) {
      _isLoading = true;
    }

    HttpService httpService = HttpService();
    Response response = await httpService.getsetup();
    var data = json.decode(response.toString());
    if (data["statusCode"] == 200) {
      _setup = Setup.fromMap(data["data"]);
      _isLoading = false;

      notifyListeners();
    }
  }
}
