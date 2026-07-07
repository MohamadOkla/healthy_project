import 'package:flutter/material.dart';

/// Design direction: a calm, clinical teal-blue (evoking Damascene ceramic
/// glaze) paired with a warm muted gold accent (evoking Levantine brass and
/// mosaic work) instead of the more generic single-teal "health app" look.
/// Semantic colors (success/warning/error) stay close to convention
/// deliberately - clarity matters more than novelty when someone is reading
/// a lab result.
abstract final class AppColors {
  // Brand - light mode
  static const Color primary = Color(0xFF0B5566);
  static const Color secondary = Color(0xFFC08A2E);

  // Soft tint of primary, used behind icon badges/avatars and as the middle
  // stop in splash/onboarding/role-selection gradients.
  static const Color primaryTint = Color(0xFFE6FFFA);

  // Brand - dark mode (brighter so they stay legible on dark surfaces)
  static const Color primaryDark = Color(0xFF4FD8C4);
  static const Color secondaryDark = Color(0xFFE0AE4E);

  // Dark-mode equivalent of primaryTint, used as the gradient middle stop
  // on dark backgrounds.
  static const Color primaryTintDark = Color(0xFF102A2E);

  // Neutrals - light mode
  static const Color background = Color(0xFFF6F8F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFEFF3F4);
  static const Color textDark = Color(0xFF13232A);
  static const Color textGrey = Color(0xFF5B6B72);

  // Neutrals - dark mode
  static const Color backgroundDark = Color(0xFF0C1A1F);
  static const Color surfaceDarkTone = Color(0xFF162B31);
  static const Color surfaceAltDark = Color(0xFF1E363D);
  static const Color textLight = Color(0xFFEAF3F3);
  static const Color textGreyDark = Color(0xFFA7BCC1);

  static const Color white = Color(0xFFFFFFFF);

  // Semantic - kept close to convention on purpose
  static const Color success = Color(0xFF15954E);
  static const Color warning = Color(0xFFC5750A);
  static const Color error = Color(0xFFD8332B);
}
