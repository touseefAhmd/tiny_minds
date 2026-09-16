import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFFFFF9F0);
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFFFFC83D);
  static const Color textDark = Color(0xFF293241);
  static const Color textLight = Color(0xFF687386);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),

      fontFamily: 'Arial',

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textDark,
        centerTitle: false,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w900,
          color: textDark,
        ),
        displayMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w900,
          color: textDark,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: textDark,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          color: textLight,
        ),
      ),
    );
  }
}