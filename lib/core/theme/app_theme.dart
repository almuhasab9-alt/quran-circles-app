import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF0B5E48); // أخضر داكن
  static const secondary = Color(0xFF12805F); // أخضر متوسط
  static const gold = Color(0xFFC9A227);
  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFE65100);
  static const danger = Color(0xFFC62828);
}

class AppTheme {
  static TextTheme _text(TextTheme base) => GoogleFonts.cairoTextTheme(base);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: _text(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(
        centerTitle: true, elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorColor: AppColors.gold,
      ),
      cardTheme: CardThemeData(
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: const Color(0xFF4CAF8A),
      secondary: AppColors.secondary,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: _text(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        centerTitle: true, elevation: 0,
        backgroundColor: scheme.surfaceContainerHighest,
        foregroundColor: Colors.white,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorColor: AppColors.gold,
      ),
      cardTheme: CardThemeData(
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
