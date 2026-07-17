import 'package:flutter/material.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import 'lab_status_chip.dart';
import 'lab_info_row.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class LabResultRowTile extends StatelessWidget {
  const LabResultRowTile({
    required this.name,
    required this.value,
    required this.normalRange,
    required this.status,
    required this.color,
  });

  final String name;
  final String value;
  final String normalRange;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(name, style: AppTextStyles.titleMedium(context))),
              LabStatusChip(label: status, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LabInfoRow(label: 'القيمة', value: value),
          LabInfoRow(label: 'المجال الطبيعي', value: normalRange),
        ],
      ),
    );
  }
}
