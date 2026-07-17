import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_sizes.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({
    super.key,
    required this.icon,
    required this.isCompact,
  });

  final IconData icon;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final size = isCompact ? 210.0 : 260.0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.84, end: 1),
      duration: const Duration(milliseconds: 680),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Opacity(
          opacity: scale.clamp(0.0, 1.0),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
            ),
            Container(
              width: size * 0.64,
              height: size * 0.64,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: AppShadows.medium,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: isCompact ? 64 : 78,
              ),
            ),
            _FloatingMedicalIcon(
              icon: Icons.favorite_rounded,
              alignment: Alignment.topRight,
              size: AppSizes.iconLg,
            ),
            _FloatingMedicalIcon(
              icon: Icons.local_hospital_rounded,
              alignment: Alignment.bottomLeft,
              size: AppSizes.iconLg,
            ),
            _FloatingMedicalIcon(
              icon: Icons.medication_rounded,
              alignment: Alignment.topLeft,
              size: AppSizes.iconMd,
            ),
            _FloatingMedicalIcon(
              icon: Icons.monitor_heart_rounded,
              alignment: Alignment.bottomRight,
              size: AppSizes.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingMedicalIcon extends StatelessWidget {
  const _FloatingMedicalIcon({
    required this.icon,
    required this.alignment,
    required this.size,
  });

  final IconData icon;
  final Alignment alignment;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size * 1.9,
        height: size * 1.9,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white.withValues(alpha: 0.92),
          boxShadow: AppShadows.soft,
        ),
        child: Icon(icon, color: AppColors.primary, size: size),
      ),
    );
  }
}
