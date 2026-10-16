import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/patient_summary.dart';

class PatientInfoCard extends StatelessWidget {
  const PatientInfoCard({super.key, required this.patient});

  final PatientSummary patient;

  @override
  Widget build(BuildContext context) {
    final unknownAllergies = patient.allergies.trim().isEmpty ||
        patient.allergies == 'لم تُسجل معلومات الحساسية';
    final noKnownAllergies = patient.allergies == 'لا توجد حساسية مسجلة';
    final allergyLabel = unknownAllergies
        ? 'لم تُسجل معلومات الحساسية'
        : noKnownAllergies
            ? 'لا توجد حساسية مسجلة'
            : patient.allergies;
    final allergyColor = unknownAllergies
        ? AppColors.warning
        : noKnownAllergies
            ? AppColors.success
            : AppColors.error;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 27,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                patient.initials,
                style: AppTextStyles.titleMedium(context).copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(patient.name, style: AppTextStyles.titleMedium(context)),
                  if (patient.age.trim().isNotEmpty)
                    Text(patient.age, style: AppTextStyles.bodyMedium(context)),
                ],
              ),
            ),
            if (patient.bloodType.trim().isNotEmpty)
              Chip(
                avatar: const Icon(Icons.bloodtype_rounded, size: 18),
                label: Text(patient.bloodType),
                visualDensity: VisualDensity.compact,
              ),
          ]),
          if (patient.chronicDiseases.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.history_rounded, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text('الأمراض المزمنة: ${patient.chronicDiseases}',
                    style: AppTextStyles.bodyMedium(context)),
              ),
            ]),
          ],
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: allergyColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: allergyColor.withValues(alpha: 0.55)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(
                unknownAllergies
                    ? Icons.help_outline_rounded
                    : noKnownAllergies
                        ? Icons.verified_user_outlined
                        : Icons.warning_amber_rounded,
                color: allergyColor,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'الحساسية: $allergyLabel',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: allergyColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
