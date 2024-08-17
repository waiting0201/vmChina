import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../theme/theme_constants.dart';
import '../language/language_provider.dart';
import '../home/home.dart';
import 'introscreen.dart';

class SplashScreen extends StatefulWidget {
  final Locale defaultLocal;
  const SplashScreen({
    required this.defaultLocal,
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late LanguageChangeProvider _languageChangeProvider;
  late String isfirsttime = "y";

  //late AnimationController _backgroundController;
  //late AnimationController _logoController;
  //late Animation<Color?> _backgroundAnimation;
  //late Animation<double> _logoAnimation;
  //late bool _isBackgroundAnimationPlayed = false;
  //late bool _isLogoAnimationPlayed = false;
  late String _currentLanguage;
  late String _currentCurrency;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      debugPrint("splashscreen init isfirsttime : $isfirsttime");

      initConnectivity();

      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

      /*_backgroundController = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      );

      _logoController = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );

      _backgroundAnimation =
          ColorTween(begin: whiteColor, end: lightbackgroundColor)
              .animate(_backgroundController)
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                _isBackgroundAnimationPlayed = true;
              }
            });

      _logoAnimation = CurvedAnimation(
        parent: _logoController,
        curve: Curves.bounceOut,
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {
              _isLogoAnimationPlayed = true;
            });
          }
        });*/

      //init();
    }
  }

  /*Future<void> _startBackgroundAnimation() async {
    if (!_isBackgroundAnimationPlayed) {
      _backgroundController.forward();
    }
  }

  Future<void> _startLogoAnimation() async {
    if (!_isLogoAnimationPlayed) {
      _logoController.forward();
    }
  }*/

  @override
  void dispose() {
    //_backgroundController.dispose();
    //_logoController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint('Couldn\'t check connectivity status $e');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    debugPrint(
        'Connectivity changed: $_connectionStatus ${_connectionStatus.last.toString()}');

    if (_connectionStatus.last != ConnectivityResult.none) {
      _connectivitySubscription.cancel();
      init();
    }
  }

  Future<void> init() async {
    _languageChangeProvider =
        Provider.of<LanguageChangeProvider>(context, listen: false);

    SharedPreferences pres = await SharedPreferences.getInstance();
    _currentLanguage = pres.getString("language_code") ?? "";

    if (_currentLanguage.isEmpty) {
      _currentLanguage =
          "${widget.defaultLocal.languageCode}-${widget.defaultLocal.countryCode}";
    }

    if (_currentLanguage == "zh-CN") {
      _currentCurrency = "CNY";
    } else {
      _currentCurrency = "EUR";
    }

    isfirsttime = pres.getString("isfirsttime") ?? "y";

    setState(() {
      isfirsttime = isfirsttime;
    });

    //pres.setString("isfirsttime", "n");
    //log("check isfirsttime : $isfirsttime");

    /*await _startBackgroundAnimation().then(
      (value) => _startLogoAnimation().then((value) {
        _languageChangeProvider
            .setRegion(_currentCurrency, _currentLanguage)
            .then((value) {
          _languageChangeProvider.changeLocale(_currentLanguage);
          _languageChangeProvider.changeCurrency(_currentCurrency);

          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    isfirsttime == "y" ? const IntroScreen() : const Home(),
              ),
            );
          });
        });
      }),
    );*/

    _languageChangeProvider
        .iniRegion(_currentCurrency, _currentLanguage)
        .then((value) {
      _languageChangeProvider.changeLocale(_currentLanguage);
      _languageChangeProvider.changeCurrency(_currentCurrency);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isfirsttime == "y" ? const IntroScreen() : const Home(),
        ),
      );
    });
  }

  @override
  //延續main檔B層MaterialApp的context
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: lightbackgroundColor,
      body: Center(
        child: Image(
          image: AssetImage('images/logo.png'),
          width: 150,
        ),
      ),
    );
  }
}
