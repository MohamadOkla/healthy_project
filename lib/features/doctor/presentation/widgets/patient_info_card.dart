import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/patient_summary.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class PatientInfoCard extends StatelessWidget {
  const PatientInfoCard({required this.patient});

  final PatientSummary patient;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
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
                Text(
                  '${patient.name} · ${patient.age}',
                  style: AppTextStyles.titleMedium(context),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${patient.gender} · فصيلة ${patient.bloodType} · ${patient.phone}',
                  style: AppTextStyles.bodyMedium(context),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'أمراض مزمنة: ${patient.chronicDiseases}',
                  style: AppTextStyles.bodyMedium(context),
                ),
                Text(
                  'حساسية: ${patient.allergies}',
                  style: AppTextStyles.bodyMedium(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
