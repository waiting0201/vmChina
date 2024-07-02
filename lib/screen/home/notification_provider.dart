import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationChangeProvider with ChangeNotifier {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  late bool _isagree = false;
  late String _message;
  late String _token;

  bool get isagree => _isagree;
  String get message => _message;
  String get token => _token;

  Future<void> requestPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    //not agree
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      _isagree = false;
      notifyListeners();
    } else {
      _isagree = true;
      notifyListeners();
    }

    await prefs.setBool('isagreenotify', _isagree);

    setNotification();
  }

  Future<void> setNotification() async {
    if (isagree) {
      //APP關閉時，透過原生Notification點進APP時的觸發點
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        StringBuffer stringBuffer = StringBuffer();
        stringBuffer.write("Got a message whilst in the getInitialMessage! \n");

        if (message != null) {
          message.data.forEach((key, value) {
            stringBuffer.write("key: $key, value: $value \n");
          });
          _message = stringBuffer.toString();
          notifyListeners();
        }
      });

      //前景接message
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        StringBuffer stringBuffer = StringBuffer();
        stringBuffer.write("Got a message whilst in the onMessage! \n");

        if (message != null) {
          message.data.forEach((key, value) {
            stringBuffer.write("key: $key, value: $value \n");
          });
          _message = stringBuffer.toString();
          notifyListeners();
        }
      });

      //APP在背景時，點Notification進入APP時的觸發點
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        StringBuffer stringBuffer = StringBuffer();
        stringBuffer
            .write("Got a message whilst in the onMessageOpenedApp! \n");

        if (message != null) {
          message.data.forEach((key, value) {
            stringBuffer.write("key: $key, value: $value \n");
          });
          _message = stringBuffer.toString();
          notifyListeners();
        }
      });
    }
  }

  Future<void> getToken() async {
    String? token = await messaging.getToken();
    if (token != null) {
      _token = token;
      notifyListeners();
    }
  }
}
