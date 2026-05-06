import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryColor = Color(0xFF4F46E5); // Modern Indigo
  static const secondaryColor = Color(0xFFEC4899); // Vibrant Pink
  static const backgroundColor = Color(0xFFF1F5F9); // Lighter slate
  static const cardColor = Colors.white;
  static const textColor = Color(0xFF0F172A); // Darker slate
  static const mutedColor = Color(0xFF64748B);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: backgroundColor,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme().apply( // Using a more modern font if possible, or stick to Inter
      bodyColor: textColor,
      displayColor: textColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        fontFamily: 'Inter',
      ),
    ),
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.grey.shade100, width: 1.5),
      ),
    ),
    scaffoldBackgroundColor: backgroundColor,
  );
}
