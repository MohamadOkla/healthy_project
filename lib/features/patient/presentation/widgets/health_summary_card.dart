import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/health_summary_model.dart';
import 'health_summary_stat.dart';

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({super.key, required this.summary});

  final HealthSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    final hasPreviousVisits = summary.lastVisit != 'لا توجد زيارات سابقة';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primary,
            Color.lerp(AppColors.primary, AppColors.primaryDark, 0.16)!,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.18),
                  ),
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'ملخصك الصحي',
                      style: AppTextStyles.titleMedium(context).copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textDark.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Text(
                        hasPreviousVisits
                            ? 'آخر زيارة: ${summary.lastVisit}'
                            : summary.lastVisit,
                        softWrap: true,
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = AppSpacing.sm;
              final scale = MediaQuery.textScalerOf(context).scale(1);
              final minimumTileWidth = 108 * scale;
              final columns =
                  (constraints.maxWidth / minimumTileWidth).floor().clamp(1, 3);
              final tileWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              final stats = [
                (
                  'المواعيد القادمة',
                  '${summary.upcomingAppointments}',
                  Icons.calendar_month_rounded,
                  AppRoutes.patientAppointments,
                ),
                (
                  'الوصفات النشطة',
                  '${summary.activePrescriptions}',
                  Icons.medication_rounded,
                  AppRoutes.patientPrescriptions,
                ),
                (
                  'النتائج الجديدة',
                  '${summary.newResults}',
                  Icons.science_rounded,
                  AppRoutes.patientLaboratory,
                ),
              ];

              return Wrap(
                textDirection: TextDirection.rtl,
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final stat in stats)
                    SizedBox(
                      width: tileWidth,
                      child: HealthSummaryStat(
                        label: stat.$1,
                        value: stat.$2,
                        icon: stat.$3,
                        route: stat.$4,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
