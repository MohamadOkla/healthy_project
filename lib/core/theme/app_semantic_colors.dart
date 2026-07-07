import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Semantic colors that must differ between light and dark mode.
///
/// [AppColors] constants are compile-time values and can't respond to the
/// active theme by themselves. Anywhere in the app that needs a
/// surface/background/text color to actually flip for dark mode should read
/// it from here (via [BuildContext.colors]) instead of reaching for
/// AppColors.white / AppColors.background / AppColors.textDark directly.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.textPrimary,
    required this.textSecondary,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color textPrimary;
  final Color textSecondary;

  static const light = AppSemanticColors(
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceAlt: AppColors.surfaceAlt,
    textPrimary: AppColors.textDark,
    textSecondary: AppColors.textGrey,
  );

  static const dark = AppSemanticColors(
    background: AppColors.backgroundDark,
    surface: AppColors.surfaceDarkTone,
    surfaceAlt: AppColors.surfaceAltDark,
    textPrimary: AppColors.textLight,
    textSecondary: AppColors.textGreyDark,
  );

  @override
  AppSemanticColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? textPrimary,
    Color? textSecondary,
  }) {
    return AppSemanticColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}

extension AppSemanticColorsX on BuildContext {
  /// Semantic colors for the active theme, e.g. `context.colors.surface`.
  AppSemanticColors get colors =>
      Theme.of(this).extension<AppSemanticColors>() ?? AppSemanticColors.light;
}
