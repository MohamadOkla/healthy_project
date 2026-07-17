import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../medical_records/domain/entities/medical_record_entry.dart';
import 'record_section_title.dart';
import 'record_info_row.dart';
import '../../../../core/theme/app_spacing.dart';

class DiagnosisCard extends StatelessWidget {
  const DiagnosisCard({required this.record});

  final MedicalRecordEntry record;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RecordSectionTitle(
            icon: Icons.health_and_safety_rounded,
            title: 'التشخيص',
          ),
          const SizedBox(height: AppSpacing.md),
          RecordInfoRow(label: 'التشخيص', value: record.diagnosis),
          if (record.symptoms.isNotEmpty)
            RecordInfoRow(label: 'الأعراض', value: record.symptoms),
          if (record.doctorNotes.isNotEmpty)
            RecordInfoRow(label: 'ملاحظات الطبيب', value: record.doctorNotes),
        ],
      ),
    );
  }
}
