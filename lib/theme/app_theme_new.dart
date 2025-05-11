import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Common Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color accentColor = Color(0xFF03DAC6);
  static const Color errorColor = Color(0xFFB00020);
  static const Color successColor = Color(0xFF4CAF50);

  // Text styles (light theme)
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF212121),
  );

  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF212121),
  );

  static TextStyle subtitle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF212121),
  );

  static TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 16,
    color: const Color(0xFF212121),
  );

  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 14,
    color: const Color(0xFF757575),
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    cardTheme: const CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(
        height: 0,
        fontSize: 0,
        color: Colors.transparent,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      hintStyle: GoogleFonts.poppins(
        fontSize: 16,
        color: const Color(0xFF757575).withOpacity(0.5),
      ),
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: accentColor,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardTheme: const CardTheme(
      color: Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor.withOpacity(0.9),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(
        height: 0,
        fontSize: 0,
        color: Colors.transparent,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      hintStyle: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.grey.withOpacity(0.5),
      ),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: primaryColor,
      secondary: accentColor,
    ),
  );
}
