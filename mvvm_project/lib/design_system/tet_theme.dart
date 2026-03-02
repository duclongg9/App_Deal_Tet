import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_project/design_system/tet_design_tokens.dart';

abstract final class TetTheme {
  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: TetColors.primary500,
      onPrimary: Colors.white,
      secondary: TetColors.accentGold,
      onSecondary: TetColors.textPrimary,
      error: TetColors.danger,
      onError: Colors.white,
      surface: TetColors.bgCard,
      onSurface: TetColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: TetColors.bgMain,
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: TetColors.textPrimary,
        displayColor: TetColors.textPrimary,
      ),
      cardTheme: CardThemeData(
        color: TetColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TetRadius.lg),
          side: const BorderSide(color: TetColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TetColors.bgCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: TetSpacing.s4, vertical: TetSpacing.s4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TetRadius.md),
          borderSide: const BorderSide(color: TetColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TetRadius.md),
          borderSide: const BorderSide(color: TetColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TetRadius.md),
          borderSide: const BorderSide(color: TetColors.primary500, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          backgroundColor: TetColors.primary500,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: TetColors.border),
          foregroundColor: TetColors.primary500,
          backgroundColor: TetColors.bgCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: StadiumBorder(),
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: TetColors.primary500,
      onPrimary: Colors.white,
      secondary: TetColors.accentGold,
      onSecondary: TetColors.darkTextPrimary,
      error: TetColors.danger,
      onError: Colors.white,
      surface: TetColors.darkBgCard,
      onSurface: TetColors.darkTextPrimary,
    );

    final base = light();
    return base.copyWith(
      colorScheme: scheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: TetColors.darkBgMain,
      cardTheme: base.cardTheme.copyWith(
        color: TetColors.darkBgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TetRadius.lg),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: TetColors.darkTextPrimary,
        displayColor: TetColors.darkTextPrimary,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: TetColors.darkBgCard,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        labelStyle: const TextStyle(color: Color(0xFFCBD5E1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TetRadius.md),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TetRadius.md),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TetRadius.md),
          borderSide: const BorderSide(color: TetColors.primary500, width: 1.2),
        ),
      ),
    );
  }
}
