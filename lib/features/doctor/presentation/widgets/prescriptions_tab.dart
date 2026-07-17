import 'package:flutter/material.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../prescriptions/domain/entities/prescription_entry.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class PrescriptionsTab extends StatelessWidget {
  const PrescriptionsTab({required this.prescriptions});

  final List<PrescriptionEntry> prescriptions;

  @override
  Widget build(BuildContext context) {
    if (prescriptions.isEmpty) {
      return const AppEmptyState(
        title: 'لا توجد وصفات بعد',
        message: 'اضغط زر الإضافة لكتابة وصفة جديدة.',
        icon: Icons.medication_outlined,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      itemCount: prescriptions.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final prescription = prescriptions[index];
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      prescription.doctorName,
                      style: AppTextStyles.titleMedium(context),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (prescription.isActive
                              ? AppColors.success
                              : context.colors.textSecondary)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Text(
                      prescription.isActive ? 'نشطة' : 'منتهية',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        fontSize: 12,
                        color: prescription.isActive
                            ? AppColors.success
                            : context.colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'من ${prescription.issueDate} حتى ${prescription.expiryDate}',
                style: AppTextStyles.bodyMedium(context),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...prescription.medicines.map(
                (medicine) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Text(
                    '• ${medicine.name} — ${medicine.dose}، '
                    '${medicine.frequency}، ${medicine.duration}',
                    style: AppTextStyles.bodyMedium(context),
                  ),
                ),
              ),
              if (prescription.notes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'ملاحظات: ${prescription.notes}',
                  style: AppTextStyles.bodyMedium(context),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
