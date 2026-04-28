// ============================================================================
//  core/theme/app_theme.dart
// ============================================================================

import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFF8B4513); // Marrón andino
  static const Color _secondaryColor = Color(0xFFD4A017); // Dorado inca
  static const Color _tertiaryColor = Color(0xFF2E8B57); // Verde cusqueño

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _primaryColor,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: _secondaryColor.withOpacity(0.15),
          labelStyle: const TextStyle(color: _primaryColor),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _primaryColor,
        brightness: Brightness.dark,
      );
}
