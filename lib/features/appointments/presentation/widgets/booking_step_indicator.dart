import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class BookingStepIndicator extends StatelessWidget {
  const BookingStepIndicator({
    super.key,
    required this.currentStep,
  });

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    const labels = ['الخدمة', 'الطبيب', 'الموعد'];
    return Row(
      children: List.generate(labels.length, (index) {
        final step = index + 1;
        final isActive = step <= currentStep;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color:
                            isActive ? AppColors.primary : context.colors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Center(
                        child: Text(
                          step.toString(),
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color:
                                isActive ? AppColors.white : AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(labels[index], style: AppTextStyles.bodyMedium(context)),
                  ],
                ),
              ),
              if (index != labels.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    color: step < currentStep
                        ? AppColors.primary
                        : AppColors.textGrey.withValues(alpha: 0.18),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
