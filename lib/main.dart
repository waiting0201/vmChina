import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:fluwx/fluwx.dart';

import 'screen/authentication/auth_provider.dart';
import 'screen/language/language_provider.dart';
import 'screen/cart/cart_provider.dart';
import 'screen/home/setup_provider.dart';
import 'screen/home/notification_provider.dart';
import 'screen/splash_screen/splashscreen.dart';
//import 'screen/splash_screen/introscreen.dart';
import 'screen/widgets/library.dart';
import 'theme/theme_constants.dart';
import 'generated/l10n.dart';
//import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );*/

  //runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Fluwx _fluwx = Fluwx();

  @override
  void initState() {
    super.initState();
    _initFluwx();
  }

  _initFluwx() async {
    await _fluwx.registerApi(
      appId: 'wx6c9eb433c4b8562f',
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: 'https://www.vetrinamia.com.cn/app/',
    );
  }

  @override
  //A層context
  Widget build(BuildContext context) {
    Locale xlocale = View.of(context).platformDispatcher.locale;
    //print("f : $xlocale");

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));

    //由於每個Page都會用到Provider，所以Provider放在最外層A層
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageChangeProvider>(
          create: (context) => LanguageChangeProvider(xlocale),
        ),
        ChangeNotifierProvider<AuthChangeProvider>(
          create: (context) => AuthChangeProvider(),
        ),
        ChangeNotifierProvider<CartChangeProvider>(
          create: (context) => CartChangeProvider(),
        ),
        ChangeNotifierProvider<SetupChangeProvider>(
          create: (context) => SetupChangeProvider(),
        ),
        /*ChangeNotifierProvider<NotificationChangeProvider>(
          create: (context) => NotificationChangeProvider(),
        ),*/
      ],
      //用Builder原因主要是產生自己的context，屬於上層MultiProvier
      child: Consumer<LanguageChangeProvider>(
        builder: (context, lang, child) {
          log("main locale : ${lang.currentLocale}");
          return MaterialApp(
            //設定現在手機的語言
            locale: lang.currentLocale,
            //委託確保加載正確語言的本地化數據
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            //App 要支援的語言
            supportedLocales: S.delegate.supportedLocales,
            //檢查手機是否支援這個語言
            localeResolutionCallback: (locale, supportLocales) {
              return setDefaultLocale(locale!, supportLocales);
            },
            debugShowCheckedModeBanner: false,
            title: '佛催拿',
            theme: lightTheme,
            home: const SplashScreen(),
            //home: const IntroScreen(),
          );
        },
      ),
    );
  }
}
