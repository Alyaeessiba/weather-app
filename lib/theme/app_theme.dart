import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF0B1437),
    scaffoldBackgroundColor: const Color(0xFF0B1437),
    cardColor: const Color(0xFF162447),
    dividerColor: const Color(0xFF1F4068),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4361EE),
      secondary: Color(0xFF48CAE4),
      surface: Color(0xFF162447),
      background: Color(0xFF0B1437),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFF8F9FA),
      onBackground: Color(0xFFF8F9FA),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFFF8F9FA),
        fontSize: 38,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFFF8F9FA),
        fontSize: 26,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFFF8F9FA),
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFFADB5BD),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xFF4361EE),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFF8F9FA),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    cardColor: Colors.white,
    dividerColor: const Color(0xFFE9ECEF),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4361EE),
      secondary: Color(0xFF48CAE4),
      surface: Colors.white,
      background: Color(0xFFF8F9FA),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1E2A3B),
      onBackground: Color(0xFF1E2A3B),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFF1E2A3B),
        fontSize: 38,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF1E2A3B),
        fontSize: 26,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF1E2A3B),
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF6C757D),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xFF4361EE),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
