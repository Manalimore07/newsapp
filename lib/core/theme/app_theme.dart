import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentIndigo = Color(0xFF4F46E5);
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: lightBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF0F172A),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Color(0xFF0F172A),
        letterSpacing: -0.5,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIconColor: const Color(0xFF64748B),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentIndigo,
      brightness: Brightness.dark,
      surface: darkSurface,
    ),
    scaffoldBackgroundColor: darkBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
    ),
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      hintStyle: const TextStyle(color: Color(0xFF64748B)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIconColor: const Color(0xFF94A3B8),
    ),
  );
}
