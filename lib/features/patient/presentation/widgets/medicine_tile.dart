import 'package:flutter/material.dart';
import 'prescription_info_row.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class MedicineTile extends StatelessWidget {
  const MedicineTile({
    required this.name,
    required this.dose,
    required this.frequency,
    required this.duration,
    required this.instructions,
  });

  final String name;
  final String dose;
  final String frequency;
  final String duration;
  final String instructions;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.sm),
          PrescriptionInfoRow(label: 'الجرعة', value: dose),
          PrescriptionInfoRow(label: 'عدد المرات', value: frequency),
          PrescriptionInfoRow(label: 'مدة الاستخدام', value: duration),
          PrescriptionInfoRow(label: 'تعليمات الاستخدام', value: instructions),
        ],
      ),
    );
  }
}
