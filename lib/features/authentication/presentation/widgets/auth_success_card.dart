import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class AuthSuccessCard extends StatelessWidget {
  const AuthSuccessCard({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.14),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primary,
              size: AppSizes.iconXl,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(title,
              style: AppTextStyles.headlineLarge(context), textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(message,
              style: AppTextStyles.bodyMedium(context), textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xl),
          AppButton(text: buttonText, onPressed: onPressed),
        ],
      ),
    );
  }
}
