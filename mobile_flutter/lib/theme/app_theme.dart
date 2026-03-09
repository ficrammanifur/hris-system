import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color secondaryColor = Color(0xFF6B7280);
  static const Color successColor = Color(0xFF22C55E);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);
  
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.grey[50],
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        minimumSize: const Size(double.infinity, 48),
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: Colors.grey[400]),
    ),
    // Hapus CardTheme sementara
  );
  
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.grey[900],
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: Color(0xFF1E1E1E),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white70),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: Colors.grey[500]),
    ),
    // Hapus CardTheme sementara
  );
}