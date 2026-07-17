import 'package:flutter/material.dart';
import 'health_summary_metric.dart';
import '../../../../core/theme/app_spacing.dart';

class HealthSummaryGrid extends StatelessWidget {
  const HealthSummaryGrid({
    required this.todayAppointmentsCount,
    required this.totalPatientsCount,
    required this.urgentCasesCount,
    required this.activePrescriptionsCount,
  });

  final int todayAppointmentsCount;
  final int totalPatientsCount;
  final int urgentCasesCount;
  final int activePrescriptionsCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 520 ? 4 : 2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: constraints.maxWidth >= 520 ? 1.25 : 1.85,
          children: [
            HealthSummaryMetric(
              title: 'مواعيد اليوم',
              value: '$todayAppointmentsCount',
            ),
            HealthSummaryMetric(
              title: 'إجمالي المرضى',
              value: '$totalPatientsCount',
            ),
            HealthSummaryMetric(
              title: 'حالات عاجلة',
              value: '$urgentCasesCount',
            ),
            HealthSummaryMetric(
              title: 'وصفات نشطة',
              value: '$activePrescriptionsCount',
            ),
          ],
        );
      },
    );
  }
}
