import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';

/// Custom Class for Light & Dark Text Themes
class TTextTheme {
  TTextTheme._(); // To avoid creating instances

  /// Customizable Light Text Theme
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 32.0,
      fontWeight: FontWeight.w800,
      color: TColors.textPrimary,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: TColors.textPrimary,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 26.0,
      fontWeight: FontWeight.bold,
      color: TColors.textPrimary,
    ),

    titleLarge: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 26.0,
      fontWeight: FontWeight.w600,
      color: TColors.textPrimary,
    ),
    titleMedium: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: TColors.textPrimary,
    ),
    titleSmall: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 24.0,
      fontWeight: FontWeight.w400,
      color: TColors.textSecondary,
    ),

    bodyLarge: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 22.0,
      fontWeight: FontWeight.w800,
      color: TColors.textPrimary,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 22.0,
      fontWeight: FontWeight.normal,
      color: TColors.textPrimary,
    ),
    bodySmall: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: TColors.textSecondary,
    ),

    labelLarge: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: TColors.textPrimary,
    ),
    labelMedium: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      color: TColors.textPrimary,
    ),
    labelSmall: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: TColors.textSecondary,
    ),
  );

  /// Customizable Dark Text Theme
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: TColors.light,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: TColors.light,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: TColors.light,
    ),

    titleLarge: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: TColors.light,
    ),
    titleMedium: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: TColors.light,
    ),
    titleSmall: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 22.0,
      fontWeight: FontWeight.w800,
      color: TColors.light,
    ),

    bodyLarge: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: TColors.light,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: TColors.light,
    ),
    bodySmall: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 20.0,
      fontWeight: FontWeight.w400,
      color: TColors.light.withOpacity(0.5),
    ),

    labelLarge: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      color: TColors.light,
    ),
    labelMedium: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: TColors.light.withOpacity(0.5),
    ),
    labelSmall: const TextStyle().copyWith(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: TColors.light,
    ),
  );
}
