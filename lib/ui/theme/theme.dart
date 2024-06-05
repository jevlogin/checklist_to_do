import 'package:flutter/material.dart';

const primaryColor = Color(0xFFF82B10);

final darkTheme = ThemeData(
    textTheme: _textTheme,
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor, brightness: Brightness.dark));

final lightTheme = ThemeData(
  textTheme: _textTheme,
  useMaterial3: true,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.grey,
  dividerTheme: DividerThemeData(
    color: Colors.grey.withOpacity(0.1),
  ),
  colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor, brightness: Brightness.light),
);

const _textTheme = TextTheme(
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600));
