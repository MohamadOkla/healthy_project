import 'package:flutter/material.dart';
import '../cubit/doctor_dashboard_state.dart';
import 'statistics_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class DoctorStatisticsGrid extends StatelessWidget {
  const DoctorStatisticsGrid({required this.state});

  final DoctorDashboardState state;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 620 ? 4 : 2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: constraints.maxWidth >= 620 ? 1.08 : 1.18,
          children: [
            StatisticsCard(
              title: 'مواعيد اليوم',
              value: '${state.todayAppointmentsCount}',
              icon: Icons.calendar_today_rounded,
              color: AppColors.primary,
            ),
            StatisticsCard(
              title: 'إجمالي المرضى',
              value: '${state.totalPatientsCount}',
              icon: Icons.group_rounded,
              color: AppColors.accentBlue,
            ),
            StatisticsCard(
              title: 'وصفات نشطة',
              value: '${state.activePrescriptionsCount}',
              icon: Icons.medication_rounded,
              color: AppColors.warning,
            ),
            StatisticsCard(
              title: 'سجلات طبية',
              value: '${state.medicalRecordsCount}',
              icon: Icons.folder_shared_rounded,
              color: AppColors.success,
            ),
          ],
        );
      },
    );
  }
}
