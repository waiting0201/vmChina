import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:app_links/app_links.dart';

//import 'model/repository.dart';
//import 'model/models.dart';
import 'screen/authentication/auth_provider.dart';
import 'screen/language/language_provider.dart';
import 'screen/cart/cart_provider.dart';
import 'screen/home/setup_provider.dart';
//import 'screen/home/notification_provider.dart';
import 'screen/splash_screen/splashscreen.dart';
//import 'screen/splash_screen/introscreen.dart';
//import 'screen/widgets/library.dart';
import 'screen/home/home.dart';
import 'screen/cart/complete.dart';
//import 'screen/authentication/log_in.dart';
import 'theme/theme_constants.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  final _navigatorKey = GlobalKey<NavigatorState>();
  final Fluwx _fluwx = Fluwx();

  late AppLinks _appLinks;
  late StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    _initFluwx();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  _initFluwx() async {
    await _fluwx.registerApi(
      appId: 'wx6c9eb433c4b8562f',
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: 'https://www.vetrinamia.com.cn/app/',
    );
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      if (uri.pathSegments[0] == 'app') {
        _navigatorKey.currentState!.pushNamedAndRemoveUntil(
          uri.toString(),
          (route) => false,
        );
      }
    });
  }

  @override
  //A層context
  Widget build(BuildContext context) {
    //Locale xlocale = View.of(context).platformDispatcher.locale;
    debugPrint("main init");

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));

    //由於每個Page都會用到Provider，所以Provider放在最外層A層
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageChangeProvider>(
          create: (context) => LanguageChangeProvider(),
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
          debugPrint("main locale : ${lang.currentLocale}");
          return MaterialApp(
            navigatorKey: _navigatorKey,
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
            /*localeResolutionCallback: (locale, supportLocales) {
              return setDefaultLocale(locale!, supportLocales);
            },*/
            debugShowCheckedModeBanner: false,
            title: '福催拿',
            theme: lightTheme,
            home: SplashScreen(
              defaultLocal: lang.currentLocale,
            ),
            //home: const IntroScreen(),
            initialRoute: "/",
            onGenerateRoute: (settings) {
              Uri uri = Uri.parse(settings.name!);

              if (uri.pathSegments.length == 1 &&
                  uri.pathSegments[0] == 'app') {
                return MaterialPageRoute(
                  builder: (context) => const Home(),
                );
              }

              // payment /app/asiapaysuccess
              if (uri.pathSegments[0] == 'app' &&
                  uri.pathSegments[1] == 'asiapaysuccess') {
                String ordercode = uri.queryParameters['Ref'] ?? '';
                String status = 'succeeded';

                return MaterialPageRoute(
                  builder: (context) => Complete(
                    ordercode: ordercode,
                    status: status,
                  ),
                );
              }

              // payment /app/asiapayfail
              if (uri.pathSegments[0] == 'app' &&
                  uri.pathSegments[1] == 'asiapayfail') {
                String ordercode = uri.queryParameters['Ref'] ?? '';
                String status = 'fail';

                return MaterialPageRoute(
                  builder: (context) => Complete(
                    ordercode: ordercode,
                    status: status,
                  ),
                );
              }

              // payment /app/asiapaycancel
              if (uri.pathSegments[0] == 'app' &&
                  uri.pathSegments[1] == 'asiapaycancel') {
                String ordercode = uri.queryParameters['Ref'] ?? '';
                String status = 'cancel';

                return MaterialPageRoute(
                  builder: (context) => Complete(
                    ordercode: ordercode,
                    status: status,
                  ),
                );
              }

              /*if (uri.pathSegments.length == 3 &&
                  uri.pathSegments[0] == 'app' &&
                  uri.pathSegments[2] == 'oauth') {
                String code = uri.queryParameters['code'] ?? '';
                return MaterialPageRoute(
                  builder: (context) => LogIn(
                    wechatcode: code,
                  ),
                );
              }*/
              return null;
            },
            onUnknownRoute: (settings) {
              return null;
            },
          );
        },
      ),
    );
  }
}
