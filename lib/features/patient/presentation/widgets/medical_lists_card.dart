import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../medical_records/domain/entities/medical_record_entry.dart';
import 'record_section_title.dart';
import 'record_bullet_list.dart';
import '../../../../core/theme/app_spacing.dart';

class MedicalListsCard extends StatelessWidget {
  const MedicalListsCard({required this.record});

  final MedicalRecordEntry record;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RecordSectionTitle(
            icon: Icons.medication_rounded,
            title: 'الخطة الطبية',
          ),
          const SizedBox(height: AppSpacing.md),
          if (record.medications.isNotEmpty) ...[
            RecordBulletList(title: 'الأدوية الموصوفة', items: record.medications),
            if (record.testsRequired.isNotEmpty)
              const SizedBox(height: AppSpacing.md),
          ],
          if (record.testsRequired.isNotEmpty)
            RecordBulletList(title: 'التحاليل المطلوبة', items: record.testsRequired),
        ],
      ),
    );
  }
}
