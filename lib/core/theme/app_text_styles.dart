import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  static TextStyle headlineLarge(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.35,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.4,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.66),
      fontSize: 15,
      fontWeight: FontWeight.w500,
      height: 1.5,
    );
  }

  /// Used only to seed [ThemeData.textTheme] in AppTheme - intentionally has
  /// no hardcoded color so Flutter/Material fills it in from the active
  /// ColorScheme (onSurface) for light vs dark automatically.
  static const TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.35,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
  );
}
