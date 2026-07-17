import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../prescriptions/domain/entities/prescription_entry.dart';
import 'prescription_section_text.dart';
import '../../../../core/theme/app_spacing.dart';

class PrescriptionNotesCard extends StatelessWidget {
  const PrescriptionNotesCard({required this.prescription});

  final PrescriptionEntry prescription;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (prescription.notes.isNotEmpty)
            PrescriptionSectionText(title: 'ملاحظات الطبيب', value: prescription.notes),
          if (prescription.notes.isNotEmpty && prescription.warnings.isNotEmpty)
            const SizedBox(height: AppSpacing.md),
          if (prescription.warnings.isNotEmpty)
            PrescriptionSectionText(title: 'التحذيرات', value: prescription.warnings),
        ],
      ),
    );
  }
}
