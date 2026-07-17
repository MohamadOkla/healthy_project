import 'dart:ui';

import 'package:flutter/material.dart';

import 'login_header_identity.dart';
import 'login_header_curve_clipper.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: LoginHeaderCurveClipper(),
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Container(color: AppColors.white.withValues(alpha: 0.10)),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  width: 236,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.32),
                    ),
                    boxShadow: AppShadows.soft,
                  ),
                  child: const LoginHeaderIdentity(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
