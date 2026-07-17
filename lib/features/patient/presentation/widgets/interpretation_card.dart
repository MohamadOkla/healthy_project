import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../laboratory/domain/entities/lab_result_entry.dart';
import 'lab_section_text.dart';
import '../../../../core/theme/app_spacing.dart';

class InterpretationCard extends StatelessWidget {
  const InterpretationCard({required this.result});

  final LabResultEntry result;

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[];
    if (result.summary.isNotEmpty) {
      sections.add(LabSectionText(title: 'تفسير مختصر', value: result.summary));
    }
    if (result.doctorNotes.isNotEmpty) {
      sections.add(
        LabSectionText(title: 'ملاحظات الطبيب', value: result.doctorNotes),
      );
    }
    if (result.recommendation.isNotEmpty) {
      sections.add(
        LabSectionText(title: 'توصيات', value: result.recommendation),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < sections.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.md),
            sections[i],
          ],
        ],
      ),
    );
  }
}
