import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/health_summary_model.dart';

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
          colors: [AppColors.primary, AppColors.secondary],
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
              _HealthScoreRing(value: summary.score),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _SummaryStat(
                label: 'مواعيد قادمة',
                value: '${summary.upcomingAppointments}',
                icon: Icons.calendar_month_rounded,
                route: AppRoutes.patientAppointments,
              ),
              _SummaryStat(
                label: 'وصفات نشطة',
                value: '${summary.activePrescriptions}',
                icon: Icons.medication_rounded,
                route: AppRoutes.patientPrescriptions,
              ),
              _SummaryStat(
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

class _HealthScoreRing extends StatelessWidget {
  const _HealthScoreRing({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'مؤشر الصحة ${(value * 100).round()} بالمئة',
      child: SizedBox.square(
        dimension: 88,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: value,
              strokeWidth: 9,
              backgroundColor: AppColors.white.withValues(alpha: 0.18),
              color: AppColors.white,
            ),
            Text(
              '${(value * 100).round()}%',
              style: AppTextStyles.titleMedium(context).copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.route,
  });

  final String label;
  final String value;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => context.go(route),
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.18),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.white, size: 22),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: AppTextStyles.titleMedium(context).copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: AppColors.white.withValues(alpha: 0.86),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
