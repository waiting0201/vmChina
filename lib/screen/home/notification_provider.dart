import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationChangeProvider with ChangeNotifier {
  late bool _isagree;
  late String _message;
  late String _token;

  bool get isagree => _isagree;
  String get message => _message;
  String get token => _token;

  Future<void> requestPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setNotification();
  }

  Future<void> setNotification() async {
    if (isagree) {
      //APP關閉時，透過原生Notification點進APP時的觸發點

      //前景接message

      //APP在背景時，點Notification進入APP時的觸發點
    }
  }
}
