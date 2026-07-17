import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../laboratory/domain/entities/lab_result_entry.dart';
import 'lab_result_row_tile.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class ResultTableCard extends StatelessWidget {
  const ResultTableCard({required this.rows});

  final List<LabResultRow> rows;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('جدول النتائج', style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.md),
          ...rows.map(
            (row) => LabResultRowTile(
              name: row.name,
              value: row.value,
              normalRange: row.normalRange,
              status: row.isNormal ? 'طبيعي' : 'غير طبيعي',
              color: row.isNormal ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}
