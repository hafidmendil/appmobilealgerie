import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextTheme getTextTheme(BuildContext context, Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final Color primaryTextColor = isDark
        ? AppColors.darkText
        : AppColors.textPrimary;
    final Color secondaryTextColor = isDark
        ? AppColors.darkSecondary
        : AppColors.textSecondary;

    final locale = Localizations.maybeLocaleOf(context);
    final isArabic = locale?.languageCode == 'ar';

    TextStyle baseStyle({
      required double fontSize,
      required FontWeight fontWeight,
      required Color color,
      double? letterSpacing,
      double? height,
    }) {
      if (isArabic) {
        return GoogleFonts.notoSansArabic(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
        );
      }
      return GoogleFonts.manrope(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );
    }

    return TextTheme(
      displayLarge: baseStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
        letterSpacing: -0.5,
      ),
      displayMedium: baseStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      headlineLarge: baseStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold, // Increased weight
        color: primaryTextColor,
      ),
      headlineMedium: baseStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold, // Increased weight
        color: primaryTextColor,
      ),
      headlineSmall: baseStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      titleLarge: baseStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold, // Increased weight
        color: primaryTextColor,
      ),
      bodyLarge: baseStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500, // Slightly more weight for body content
        color: primaryTextColor,
        height: 1.5,
      ),
      bodyMedium: baseStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: secondaryTextColor, // Still visible but secondary
        height: 1.4,
      ),
      bodySmall: baseStyle(
        fontSize: 12,
        fontWeight:
            FontWeight.w500, // Small text needs more weight to be readable
        color:
            primaryTextColor, // Use primary for small text to ensure visibility
      ),
      labelLarge: baseStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold, // Increased weight for labels
        color: primaryTextColor,
      ),
    );
  }

  // Helper for Arabic text which might need specific styling
  static TextStyle arabicStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return GoogleFonts.notoSansArabic(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
