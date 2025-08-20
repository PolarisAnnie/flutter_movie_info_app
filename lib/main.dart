import 'package:flutter/material.dart';
import 'package:flutter_movie_info_app/presentation/pages/home/home_page.dart';
import 'package:flutter_movie_info_app/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.DarkTheme,
      themeMode: ThemeMode.dark,
      home: HomePage(),
    );
  }
}
