import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../prescriptions/domain/entities/prescription_entry.dart';
import 'medicine_tile.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class MedicineListCard extends StatelessWidget {
  const MedicineListCard({required this.medicines});

  final List<PrescriptionMedicine> medicines;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('قائمة الأدوية', style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.md),
          ...medicines.map(
            (medicine) => MedicineTile(
              name: medicine.name,
              dose: medicine.dose,
              frequency: medicine.frequency,
              duration: medicine.duration,
              instructions: medicine.instructions,
            ),
          ),
        ],
      ),
    );
  }
}
