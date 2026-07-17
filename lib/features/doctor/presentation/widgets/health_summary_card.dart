import 'package:flutter/material.dart';

import 'health_summary_grid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({
    super.key,
    required this.todayAppointmentsCount,
    required this.totalPatientsCount,
    required this.urgentCasesCount,
    required this.activePrescriptionsCount,
  });

  final int todayAppointmentsCount;
  final int totalPatientsCount;
  final int urgentCasesCount;
  final int activePrescriptionsCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: theme.colorScheme.brightness == Brightness.dark
              ? const [AppColors.summaryGradientDarkStart, AppColors.summaryGradientDarkEnd]
              : const [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: const Icon(
                  Icons.monitor_heart_rounded,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ملخص العيادة',
                      style: AppTextStyles.titleMedium(context).copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'نظرة سريعة على نشاطك الطبي',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.white.withValues(alpha: 0.78),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          HealthSummaryGrid(
            todayAppointmentsCount: todayAppointmentsCount,
            totalPatientsCount: totalPatientsCount,
            urgentCasesCount: urgentCasesCount,
            activePrescriptionsCount: activePrescriptionsCount,
          ),
        ],
      ),
    );
  }
}
