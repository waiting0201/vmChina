import 'dart:developer';

import 'package:flutter/material.dart';

String stripHtml(String? text) {
  if (text == null || text == '') return '';
  return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
}

String convertCurrency(double price, double exchange) {
  double result = price * exchange;
  return result.toStringAsFixed(0);
}

Locale setDefaultLocale(Locale locale, Iterable<Locale> supportedlocales) {
  log("set : $locale");

  for (Locale supportedLocale in supportedlocales) {
    if (locale.languageCode == supportedLocale.languageCode) {
      if (locale.languageCode == 'zh') {
        if (locale.countryCode == 'CN') {
          return const Locale.fromSubtags(
            languageCode: "zh",
            scriptCode: "Hans",
            countryCode: "CN",
          );
        } /*else if (locale.countryCode == "TW") {
          return const Locale.fromSubtags(
            languageCode: "zh",
            scriptCode: "Hant",
            countryCode: "TW",
          );
        } else if (locale.countryCode == "HK") {
          return const Locale.fromSubtags(
            languageCode: "zh",
            scriptCode: "Hant",
            countryCode: "HK",
          );
        }*/
        else {
          return const Locale.fromSubtags(
            languageCode: "en",
            countryCode: "US",
          );
        }
        /*} else if (locale.languageCode == 'ja') {
        return const Locale.fromSubtags(
          languageCode: "ja",
          countryCode: "JP",
        );
      } else if (locale.languageCode == 'ko') {
        return const Locale.fromSubtags(
          languageCode: "ko",
          countryCode: "KR",
        );*/
      } else if (locale.languageCode == 'en') {
        return const Locale.fromSubtags(
          languageCode: "en",
          countryCode: "US",
        );
      }
      return locale;
    }
  }

  return const Locale("en", "US");
}

List<TextSpan> parseTextWithStyles(String text) {
  final List<TextSpan> spans = [];
  final parts = text.split(RegExp(r'\{|\}'));

  RegExp regExp = RegExp(r'\{(.*?)\}');
  Iterable<Match> matches = regExp.allMatches(text);
  List<String> extractedTexts =
      matches.map((match) => match.group(1)!).toList();

  for (var part in parts) {
    if (extractedTexts.contains(part)) {
      spans.add(
        TextSpan(
          text: part,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
          //recognizer: TapGestureRecognizer()..onTap = () {},
        ),
      );
    } else {
      spans.add(TextSpan(text: part));
    }
  }

  return spans;
}

String capitalizeFirstLetter(String word) {
  if (word.isEmpty) {
    return word; // Return empty string if input is empty
  }
  return word[0].toUpperCase() + word.substring(1).toLowerCase();
}

Color hexToColor(String hexString) {
  final buffer = StringBuffer();

  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));

  return Color(int.parse(buffer.toString(), radix: 16));
}
