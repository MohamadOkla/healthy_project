import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class LoginHeaderIdentity extends StatelessWidget {
  const LoginHeaderIdentity();

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
