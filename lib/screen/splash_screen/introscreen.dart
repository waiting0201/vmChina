import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../widgets/common.dart';
import '../home/home.dart';
import '../home/notification_provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({
    super.key,
  });

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late NotificationChangeProvider _notificationChangeProvider;

  @override
  void initState() {
    super.initState();
    _notificationChangeProvider =
        Provider.of<NotificationChangeProvider>(context, listen: false);
  }

  Widget _buildFullscreenImage(String image) {
    return Image.asset(
      'images/$image',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String image) {
    return Image.asset(
      'images/$image',
      fit: BoxFit.fill,
    );
  }

  @override
  //延續main檔B層MaterialApp的context
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    const pageDecoration = PageDecoration(
      fullScreen: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        height: 1,
        color: whiteColor,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: shadowColor,
            offset: Offset(1.0, 1.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      bodyTextStyle: TextStyle(
        fontSize: 15,
        color: whiteColor,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: shadowColor,
            offset: Offset(1.0, 1.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      contentMargin: EdgeInsets.all(0),
      titlePadding: EdgeInsets.only(left: 40, right: 40, bottom: 20),
      bodyPadding: EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 20),
      bodyAlignment: Alignment.bottomCenter,
    );

    return IntroductionScreen(
      globalBackgroundColor: whiteColor,
      pages: [
        PageViewModel(
          title: lang.S.of(context).introscreenP1Title,
          body: lang.S.of(context).introscreenP1Caption,
          image: _buildFullscreenImage("splash-img.jpg"),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: lang.S.of(context).introscreenP2Title,
          body: lang.S.of(context).introscreenP2Caption,
          image: _buildFullscreenImage("intro_01.jpg"),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: lang.S.of(context).introscreenP3Title,
          body: lang.S.of(context).introscreenP3Caption,
          image: _buildFullscreenImage("intro_02.jpg"),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: lang.S.of(context).introscreenP4Title,
          body: lang.S.of(context).introscreenP4Caption,
          decoration: pageDecoration.copyWith(
            fullScreen: false,
            titleTextStyle: const TextStyle(
              fontSize: 22,
              height: 1,
            ),
            bodyTextStyle: const TextStyle(
              fontSize: 15,
            ),
            bodyAlignment: Alignment.center,
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: const AccountSection(),
          image: _buildImage("intro_04.jpg"),
          decoration: pageDecoration.copyWith(
            fullScreen: false,
            titlePadding: const EdgeInsets.all(0),
            bodyAlignment: Alignment.center,
            pageMargin: const EdgeInsets.all(0),
            descriptionPadding: const EdgeInsets.all(0),
            imagePadding:
                const EdgeInsets.only(top: 60, left: 0, right: 0, bottom: 0),
            imageFlex: 2,
          ),
        ),
      ],
      showSkipButton: true,
      showNextButton: true,
      showDoneButton: true,
      skip: Text(
        lang.S.of(context).introscreenSkip,
        style: textTheme.bodyMedium!.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      next: const Icon(Icons.arrow_forward),
      done: Text(
        lang.S.of(context).introscreenEnter,
        style: textTheme.bodyMedium!.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      onChange: (value) {
        if (value == 3) {
          _notificationChangeProvider.requestPermission();
        }
      },
      onSkip: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Home()),
        );
      },
      onDone: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Home()),
        );
      },
    );
  }
}
