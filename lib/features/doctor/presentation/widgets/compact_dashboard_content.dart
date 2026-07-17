import 'package:flutter/material.dart';
import '../cubit/doctor_dashboard_state.dart';
import 'health_summary_card.dart';
import 'quick_actions_grid.dart';
import 'recent_patients_section.dart';
import 'today_schedule_section.dart';
import 'doctor_statistics_grid.dart';
import '../../../../core/theme/app_spacing.dart';

class CompactDashboardContent extends StatelessWidget {
  const CompactDashboardContent({required this.state});

  final DoctorDashboardState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DoctorStatisticsGrid(state: state),
        const SizedBox(height: AppSpacing.xl),
        const QuickActionsGrid(),
        const SizedBox(height: AppSpacing.xl),
        TodayScheduleSection(appointments: state.todayAppointments),
        const SizedBox(height: AppSpacing.xl),
        RecentPatientsSection(patients: state.patients),
        const SizedBox(height: AppSpacing.xl),
        HealthSummaryCard(
          todayAppointmentsCount: state.todayAppointmentsCount,
          totalPatientsCount: state.totalPatientsCount,
          urgentCasesCount: state.urgentCasesCount,
          activePrescriptionsCount: state.activePrescriptionsCount,
        ),
      ],
    );
  }
}
