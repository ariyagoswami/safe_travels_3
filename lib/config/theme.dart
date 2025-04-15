import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color primaryBlue = Color(0xFF1E5DC8);
  static const Color secondaryYellow = Color(0xFFFFCD00);
  static const Color accentGreen = Color(0xFF4CD964);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color lightGray = Color(0xFFF5F5F5);

  // Typography
  static const double headerFontSize = 20.0;
  static const double buttonFontSize = 16.0;
  static const double bodyFontSize = 16.0;
  static const double labelFontSize = 14.0;

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryBlue,
        secondary: secondaryYellow,
        tertiary: accentGreen,
        background: white,
        surface: white,
        onPrimary: white,
        onSecondary: black,
        onTertiary: white,
        onBackground: black,
        onSurface: black,
      ),
      scaffoldBackgroundColor: white,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: headerFontSize,
          fontWeight: FontWeight.bold,
          color: white,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: headerFontSize,
          fontWeight: FontWeight.bold,
          color: black,
        ),
        bodyLarge: TextStyle(
          fontSize: bodyFontSize,
          color: black,
        ),
        labelLarge: TextStyle(
          fontSize: labelFontSize,
          color: black,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGreen,
          foregroundColor: white,
          textStyle: const TextStyle(
            fontSize: buttonFontSize,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: secondaryYellow,
        selectedItemColor: black,
        unselectedItemColor: black.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(
          fontSize: labelFontSize,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: labelFontSize,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
