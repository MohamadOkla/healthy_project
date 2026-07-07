import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HeaderCurveClipper(),
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
                  child: const _HeaderIdentity(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIdentity extends StatelessWidget {
  const _HeaderIdentity();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: 'Medical logo',
          child: Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            child: const Icon(
              Icons.health_and_safety_rounded,
              color: AppColors.primary,
              size: AppSizes.iconXl,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppStrings.appNameEn,
          style: AppTextStyles.titleMedium(context).copyWith(color: AppColors.white),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppStrings.appNameAr,
          style: AppTextStyles.bodyMedium(context).copyWith(color: AppColors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 42)
      ..quadraticBezierTo(
        size.width / 2,
        size.height + 28,
        size.width,
        size.height - 42,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
