import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    const activities = [
      (
        Icons.science_rounded,
        'تمت إضافة نتيجة تحليل جديدة',
        AppRoutes.patientLaboratoryDetails,
      ),
      (
        Icons.medication_rounded,
        'تم تحديث الوصفة الطبية',
        AppRoutes.patientPrescriptionDetails,
      ),
      (
        Icons.event_available_rounded,
        'تم تأكيد موعدك القادم',
        AppRoutes.patientAppointmentDetails,
      ),
    ];

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'آخر النشاطات',
            style: AppTextStyles.titleMedium(context).copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...activities.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: InkWell(
                onTap: () => context.go(item.$3),
                splashFactory: NoSplash.splashFactory,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child:
                            Icon(item.$1, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(item.$2, style: AppTextStyles.bodyMedium(context)),
                      ),
                      const Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
