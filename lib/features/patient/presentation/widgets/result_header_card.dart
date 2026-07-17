import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../laboratory/domain/entities/lab_result_entry.dart';
import 'lab_title_row.dart';
import 'lab_info_row.dart';
import '../../../../core/theme/app_spacing.dart';

class ResultHeaderCard extends StatelessWidget {
  const ResultHeaderCard({required this.result});

  final LabResultEntry result;

  @override
  Widget build(BuildContext context) {
    final hasAbnormal = result.rows.any((row) => !row.isNormal);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabTitleRow(hasAbnormal: hasAbnormal),
          const SizedBox(height: AppSpacing.md),
          LabInfoRow(label: 'اسم التحليل', value: result.testName),
          LabInfoRow(label: 'تاريخ التحليل', value: result.testDate),
          LabInfoRow(label: 'المخبر أو المشفى', value: result.labName),
          LabInfoRow(
            label: 'حالة النتيجة',
            value: result.isCompleted ? 'مكتملة' : 'قيد الإجراء',
          ),
          if (result.summary.isNotEmpty)
            LabInfoRow(label: 'ملخص النتيجة', value: result.summary),
        ],
      ),
    );
  }
}
