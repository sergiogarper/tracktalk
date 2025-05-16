import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        primaryColor: const Color(0xFF2E4E45),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: TextStyle(letterSpacing: -1.0),
          displayMedium: TextStyle(letterSpacing: -1.0),
          displaySmall: TextStyle(letterSpacing: -1.0),
          headlineLarge: TextStyle(letterSpacing: -1.0),
          headlineMedium: TextStyle(letterSpacing: -1.0),
          headlineSmall: TextStyle(letterSpacing: -1.0),
          titleLarge: TextStyle(letterSpacing: -1.0),
          titleMedium: TextStyle(letterSpacing: -1.0),
          titleSmall: TextStyle(letterSpacing: -1.0),
          bodyLarge: TextStyle(letterSpacing: -1.0),
          bodyMedium: TextStyle(letterSpacing: -1.0),
          bodySmall: TextStyle(letterSpacing: -1.0),
          labelLarge: TextStyle(letterSpacing: -1.0),
          labelMedium: TextStyle(letterSpacing: -1.0),
          labelSmall: TextStyle(letterSpacing: -1.0),
        ),
      );
}
