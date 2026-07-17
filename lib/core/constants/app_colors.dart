import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF0B5566);

  static const Color primaryTint = Color(0xFFE6FFFA);

  static const Color primaryDark = Color(0xFF4FD8C4);

  static const Color primaryTintDark = Color(0xFF102A2E);

  static const Color background = Color(0xFFF6F8F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFEFF3F4);
  static const Color textDark = Color(0xFF13232A);
  static const Color textGrey = Color(0xFF5B6B72);

  static const Color backgroundDark = Color(0xFF0C1A1F);
  static const Color surfaceDarkTone = Color(0xFF162B31);
  static const Color surfaceAltDark = Color(0xFF1E363D);
  static const Color textLight = Color(0xFFEAF3F3);
  static const Color textGreyDark = Color(0xFFA7BCC1);

  static const Color white = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF15954E);
  static const Color warning = Color(0xFFC5750A);
  static const Color error = Color(0xFFD8332B);

  // Dark-mode error (lightened so it stays legible on dark surfaces).
  static const Color errorDark = Color(0xFFEF7A73);

  // Accent hues - used ONLY to differentiate items in lists/grids
  // (avatars, statistics cards, chart series). These are not brand
  // colors; never hardcode their hex values inside screens - always
  // reference them (or [accentPalette]) from here.
  static const Color accentBlue = Color(0xFF2563EB);
  static const Color accentViolet = Color(0xFF7C3AED);
  static const Color accentOrange = Color(0xFFEA580C);
  static const Color accentCyan = Color(0xFF0891B2);

  /// Shared rotation palette for avatars, statistics cards, and chart
  /// series. Screens should index into this (usually `% length`)
  /// instead of declaring their own local palettes.
  static const List<Color> accentPalette = [
    primary,
    accentBlue,
    accentViolet,
    accentOrange,
    accentCyan,
    success,
  ];

  // Health-summary card gradient - dark mode stops (deep teal -> midnight).
  static const Color summaryGradientDarkStart = Color(0xFF134E4A);
  static const Color summaryGradientDarkEnd = Color(0xFF0F172A);
}
