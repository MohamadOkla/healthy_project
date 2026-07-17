import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../medical_records/domain/entities/medical_record_entry.dart';
import 'record_section_title.dart';
import 'record_info_row.dart';
import '../../../../core/theme/app_spacing.dart';

class VisitHeaderCard extends StatelessWidget {
  const VisitHeaderCard({required this.record});

  final MedicalRecordEntry record;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RecordSectionTitle(
            icon: Icons.assignment_rounded,
            title: 'معلومات الزيارة',
          ),
          const SizedBox(height: AppSpacing.md),
          RecordInfoRow(label: 'اسم الطبيب', value: record.doctorName),
          RecordInfoRow(label: 'الاختصاص', value: record.specialty),
          RecordInfoRow(label: 'اسم المشفى', value: record.hospital),
          RecordInfoRow(label: 'تاريخ الزيارة', value: record.visitDate),
        ],
      ),
    );
  }
}
