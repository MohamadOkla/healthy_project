import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import 'record_section_title.dart';
import 'vital_chip.dart';
import '../../../../core/theme/app_spacing.dart';

class VitalsCard extends StatelessWidget {
  const VitalsCard({required this.vitals});

  final List<(String, String)> vitals;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RecordSectionTitle(
            icon: Icons.monitor_heart_rounded,
            title: 'العلامات الحيوية',
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: vitals
                .map((item) => VitalChip(label: item.$1, value: item.$2))
                .toList(),
          ),
        ],
      ),
    );
  }
}
