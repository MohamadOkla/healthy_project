import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    AppColors.backgroundDark,
                    AppColors.primaryTintDark,
                    AppColors.surfaceDarkTone,
                  ]
                : const [
                    AppColors.background,
                    AppColors.primaryTint,
                    AppColors.white,
                  ],
          ),
        ),
        child: SizedBox.expand(child: child),
      ),
    );
  }
}
