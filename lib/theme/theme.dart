import 'package:flutter/material.dart';

class AppTheme {
  // 폰트 사이즈
  static const double headerFontSize = 80.0;
  static const double titleFontSize = 16.0;
  static const double bodyFontSize = 12.0;

  // 폰트 굵기
  static const FontWeight headerFontWeight = FontWeight.w800;
  static const FontWeight titleFontWeight = FontWeight.w600;
  static const FontWeight bodyFontWeight = FontWeight.w400;

  // 텍스트 스타일
  static const TextStyle headerStyle = TextStyle(
    fontSize: headerFontSize,
    fontWeight: headerFontWeight,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: titleFontSize,
    fontWeight: titleFontWeight,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: bodyFontSize,
    fontWeight: bodyFontWeight,
  );

  static ThemeData DarkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Paperlogy',
    colorScheme: const ColorScheme.dark(
      primary: Colors.yellow,
      onPrimary: Colors.white,
      onSurface: Colors.white,
    ),
  );
}
