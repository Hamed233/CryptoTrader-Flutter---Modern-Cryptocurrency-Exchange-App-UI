import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // App colors
  static const Color primaryColor = Color(0xFF2151F5);
  static const Color secondaryColor = Color(0xFF1E2026);
  static const Color accentColor = Color(0xFFF0B90B);
  
  // Background colors
  static const Color darkBackground = Color(0xFF0B0E11);
  static const Color cardDarkBackground = Color(0xFF1E2026);
  static const Color cardLightBackground = Color(0xFF2B3139);
  
  // Text colors
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF848E9C);
  static const Color textLightGrey = Color(0xFFB7BDC6);
  
  // Price colors
  static const Color priceUp = Color(0xFF03A66D);
  static const Color priceDown = Color(0xFFCF304A);
  
  // Chart colors
  static const Color chartLine = Color(0xFF2151F5);
  static const Color chartGradientStart = Color(0x662151F5);
  static const Color chartGradientEnd = Color(0x002151F5);
  
  // Get dark theme data
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      background: darkBackground,
      surface: cardDarkBackground,
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme.copyWith(
        displayLarge: const TextStyle(
          color: textWhite,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: const TextStyle(
          color: textWhite,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: const TextStyle(
          color: textWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: const TextStyle(
          color: textWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: const TextStyle(
          color: textWhite,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: const TextStyle(
          color: textWhite,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: const TextStyle(
          color: textWhite,
          fontSize: 16,
        ),
        bodyMedium: const TextStyle(
          color: textLightGrey,
          fontSize: 14,
        ),
        labelLarge: const TextStyle(
          color: textWhite,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textWhite,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: textWhite),
    ),
    cardTheme: const CardTheme(
      color: cardDarkBackground,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: textWhite,
      unselectedLabelColor: textGrey,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColor, width: 2.0),
        insets: EdgeInsets.symmetric(horizontal: 16.0),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: cardDarkBackground,
      selectedItemColor: primaryColor,
      unselectedItemColor: textGrey,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: cardLightBackground,
      filled: true,
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
        borderSide: const BorderSide(color: primaryColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: textGrey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textWhite,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2B3139),
      thickness: 1,
      space: 1,
    ),
  );
}
