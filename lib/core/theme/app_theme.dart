import 'package:flutter/material.dart';
import 'tokens/app_colors.dart';
import 'tokens/app_typography.dart';
import 'tokens/app_spacing.dart';
import 'tokens/app_radii.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.oliveGreen,
        primary: AppColors.oliveGreen,
        onPrimary: Colors.white,
        secondary: AppColors.skyBlue,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.softCream,
        onSurface: AppColors.textPrimary,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.warmBeige,
      textTheme: AppTypography.getTextTheme(context, Brightness.light),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.oliveGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.mediumRadius),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.oliveGreen,
          side: const BorderSide(color: AppColors.oliveGreen, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.mediumRadius),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.largeRadius),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white, // Pure white for better contrast
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadii.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.textMuted,
            width: 1,
          ), // Stronger border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.mediumRadius,
          borderSide: BorderSide(
            color: AppColors.textMuted.withAlpha(128),
          ), // More visible
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.oliveGreen,
            width: 2.5,
          ), // Stronger focus
        ),
        labelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkBackground,
        secondary: AppColors.skyBlue,
        onSecondary: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkText,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: AppTypography.getTextTheme(context, Brightness.dark),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkBackground,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.mediumRadius),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.mediumRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.darkPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadii.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.darkSecondary,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.mediumRadius,
          borderSide: BorderSide(color: AppColors.darkSecondary.withAlpha(128)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.mediumRadius,
          borderSide: const BorderSide(
            color: AppColors.darkPrimary,
            width: 2.5,
          ),
        ),
        labelStyle: const TextStyle(
          color: AppColors.darkText,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: const TextStyle(color: AppColors.darkSecondary),
        prefixIconColor: AppColors.darkSecondary,
        suffixIconColor: AppColors.darkSecondary,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.largeRadius),
        color: AppColors.darkCard,
      ),
    );
  }
}
