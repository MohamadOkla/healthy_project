import 'package:flutter/material.dart';
import 'lab_status_chip.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class LabTitleRow extends StatelessWidget {
  const LabTitleRow({required this.hasAbnormal});

  final bool hasAbnormal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.science_rounded, color: AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'نتيجة التحليل',
            style: AppTextStyles.titleMedium(context).copyWith(color: AppColors.primary),
          ),
        ),
        LabStatusChip(
          label: hasAbnormal ? 'يحتاج متابعة' : 'طبيعي',
          color: hasAbnormal ? AppColors.warning : AppColors.success,
        ),
      ],
    );
  }
}
