import 'package:flutter/material.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../prescriptions/domain/entities/prescription_entry.dart';
import 'prescription_status_chip.dart';
import 'prescription_info_row.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class PrescriptionHeader extends StatelessWidget {
  const PrescriptionHeader({required this.prescription});

  final PrescriptionEntry prescription;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medication_rounded, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'الوصفة رقم ${prescription.id.toUpperCase()}',
                  style: AppTextStyles.titleMedium(context)
                      .copyWith(color: AppColors.primary),
                ),
              ),
              PrescriptionStatusChip(
                label: prescription.isActive ? 'نشطة' : 'منتهية',
                color: prescription.isActive
                    ? AppColors.success
                    : context.colors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          PrescriptionInfoRow(label: 'اسم الطبيب', value: prescription.doctorName),
          PrescriptionInfoRow(label: 'تاريخ الإصدار', value: prescription.issueDate),
          PrescriptionInfoRow(
              label: 'تاريخ انتهاء الوصفة', value: prescription.expiryDate),
        ],
      ),
    );
  }
}
