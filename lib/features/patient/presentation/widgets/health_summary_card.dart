import 'package:flutter/material.dart';

import '../models/health_summary_model.dart';
import 'health_score_ring.dart';
import 'health_summary_stat.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({super.key, required this.summary});

  final HealthSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.16),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'حالتك الصحية مستقرة',
                            style: AppTextStyles.titleMedium(context).copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'آخر زيارة: ${summary.lastVisit}',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.white.withValues(alpha: 0.86),
                      ),
                    ),
                  ],
                ),
              ),
              HealthScoreRing(value: summary.score),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              HealthSummaryStat(
                label: 'مواعيد قادمة',
                value: '${summary.upcomingAppointments}',
                icon: Icons.calendar_month_rounded,
                route: AppRoutes.patientAppointments,
              ),
              HealthSummaryStat(
                label: 'وصفات نشطة',
                value: '${summary.activePrescriptions}',
                icon: Icons.medication_rounded,
                route: AppRoutes.patientPrescriptions,
              ),
              HealthSummaryStat(
                label: 'نتيجة جديدة',
                value: '${summary.newResults}',
                icon: Icons.science_rounded,
                route: AppRoutes.patientLaboratory,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
