import 'package:flutter/material.dart';

const primaryColor = Color(0xffb4a189);
const lightTitleColor = Color(0xff0d1414);
const lightGreyTextColor = Color(0xff9da3a3);
const darkTitleColor = Color(0xffdeeff6);
const lightIconColor = Color(0xff0d1414);
const darkIconColor = Color(0xffdeeff6);
const lightPrimary = Color(0xfff4f2ee);
const darkPrimary = Color(0xff182125);

const whiteColor = Color(0xffffffff);
const redColor = Color(0xffff0000);
const orangeColor = Color(0xffffa500);
const darkColor = Color(0xff212529);
const lightbackgroundColor = Color(0xffeeeee4);
const bggray100 = Color(0xfff8f9fa);
const captiongray = Color(0xff333333);
const shadowColor = Color(0xff444444);
const shimmerbaseColor = Color(0xffE0E0E0);
const shimmerhilightColor = Color(0xffF5F5F5);
const disablegrayColor = Color(0xFFCCCCCC);
const infoColor = Color(0xff11A2B8);
const wechatColor = Color(0xff09B83E);

ThemeData lightTheme = ThemeData(
  textTheme: const TextTheme(
    /*display用在ListTile相關*/
    displayLarge: TextStyle(
        color: Color(0xffffffff), fontSize: 19, fontWeight: FontWeight.bold),
    //商品標題
    displayMedium: TextStyle(
        color: Color(0xff0d1414), fontSize: 14, fontWeight: FontWeight.bold),
    //商品副標
    displaySmall: TextStyle(
        color: Color(0xffa7a7a7), fontSize: 12, fontWeight: FontWeight.w400),
    /*title用在Page標題相關*/
    titleLarge: TextStyle(
        color: Color(0xff0d1414), fontSize: 20, fontWeight: FontWeight.w400),
    //商品標題
    titleMedium: TextStyle(
        color: Color(0xff0d1414), fontSize: 18, fontWeight: FontWeight.bold),
    //商品副標
    titleSmall: TextStyle(
        color: Color(0xffa7a7a7), fontSize: 12, fontWeight: FontWeight.w400),
    /*body用在Page內文相關*/
    bodyLarge: TextStyle(
        color: Color(0xff0d1414), fontSize: 18, fontWeight: FontWeight.w400),
    //內文或簡介
    bodyMedium: TextStyle(
        color: Color(0xff0d1414), fontSize: 14, fontWeight: FontWeight.w400),
    //小說明文字
    bodySmall: TextStyle(
        color: Color(0xff0d1414), fontSize: 12, fontWeight: FontWeight.w400),
    /*label用在Card Overlay相關*/
    labelLarge: TextStyle(
        color: Color(0xffffffff), fontSize: 24, fontWeight: FontWeight.bold),
    labelMedium: TextStyle(
      color: Color(0xffffffff),
      fontSize: 18,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          color: shadowColor,
          offset: Offset(1.0, 1.0),
          blurRadius: 5.0,
        ),
      ],
    ),
    labelSmall: TextStyle(
        color: Color(0xffffffff), fontSize: 14, fontWeight: FontWeight.bold),
  ),
  brightness: Brightness.light,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      backgroundColor: primaryColor,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
    ),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    brightness: Brightness.light,
    primary: const Color(0xffb4a189),
    secondary: const Color(0xffff4f58),
    onPrimary: const Color(0xff0b1214),
    primaryContainer: const Color(0xff9cebeb),
    secondaryContainer: const Color(0xffffffff),
    tertiary: const Color(0xffbf4a50),
    error: const Color(0xffb00020),
    errorContainer: const Color(0xfffcd8df),
    outline: const Color(0xff565656),
    shadow: const Color(0xff444444),
  ),
  dividerColor: Colors.transparent,
  fontFamily: 'Avenir',
);
