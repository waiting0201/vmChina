import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/theme_constants.dart';
//import '../language/language_provider.dart';
import '../home/home.dart';
import 'introscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  //late LanguageChangeProvider _languageChangeProvider;
  late String isfirsttime = "y";

  late AnimationController _backgroundController;
  late AnimationController _logoController;
  late Animation<Color?> _backgroundAnimation;
  late Animation<double> _logoAnimation;
  late bool _isBackgroundAnimationPlayed = false;
  late bool _isLogoAnimationPlayed = false;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      debugPrint("init isfirsttime : $isfirsttime");

      _backgroundController = AnimationController(
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
        });

      init();
    }
  }

  Future<void> _startBackgroundAnimation() async {
    if (!_isBackgroundAnimationPlayed) {
      _backgroundController.forward();
    }
  }

  Future<void> _startLogoAnimation() async {
    if (!_isLogoAnimationPlayed) {
      _logoController.forward();
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  Future<void> init() async {
    //_languageChangeProvider =
    //Provider.of<LanguageChangeProvider>(context, listen: false);

    SharedPreferences pres = await SharedPreferences.getInstance();
    isfirsttime = pres.getString("isfirsttime") ?? "y";

    setState(() {
      isfirsttime = isfirsttime;
    });

    //pres.setString("isfirsttime", "n");
    //log("check isfirsttime : $isfirsttime");

    await _startBackgroundAnimation().then(
      (value) => _startLogoAnimation().then((value) {
        /*_languageChangeProvider.setRegion().then((value) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    isfirsttime == "y" ? const IntroScreen() : const Home(),
              ),
            );
          });
        });*/
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  isfirsttime == "y" ? const IntroScreen() : const Home(),
            ),
          );
        });
      }),
    );
  }

  @override
  //延續main檔B層MaterialApp的context
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            color: _backgroundAnimation.value,
            child: Center(
              child: ScaleTransition(
                scale: _logoAnimation,
                child: const Image(
                  image: AssetImage('images/logo.png'),
                  width: 150,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
