import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class RegisterStepIndicator extends StatelessWidget {
  const RegisterStepIndicator({
    super.key,
    required this.currentStep,
  });

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    const labels = ['البيانات', 'الملف', 'الأمان'];

    return Row(
      children: List.generate(labels.length, (index) {
        final isActive = index <= currentStep;
        return Expanded(
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textGrey.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                labels[index],
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: isActive ? AppColors.primary : context.colors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
