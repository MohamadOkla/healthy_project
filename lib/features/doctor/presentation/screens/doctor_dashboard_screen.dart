import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/doctor_dashboard_cubit.dart';
import '../cubit/doctor_dashboard_state.dart';
import '../widgets/doctor_bottom_navigation.dart';
import '../widgets/doctor_dashboard_header.dart';
import '../widgets/health_summary_card.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_patients_section.dart';
import '../widgets/statistics_card.dart';
import '../widgets/today_schedule_section.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorDashboardCubit(),
      child: const Scaffold(
        body: SafeArea(
          child: _DoctorDashboardBody(),
        ),
        bottomNavigationBar: DoctorBottomNavigation(selectedIndex: 0),
      ),
    );
  }
}

class _DoctorDashboardBody extends StatelessWidget {
  const _DoctorDashboardBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
      builder: (context, state) {
        return ColoredBox(
          color: theme.colorScheme.brightness == Brightness.dark
              ? theme.scaffoldBackgroundColor
              : AppColors.background,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 920;
              final maxWidth = isWide ? 1180.0 : 680.0;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.md,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: DoctorDashboardHeader(
                            doctorName: state.doctorName,
                            todayAppointmentsCount:
                                state.todayAppointmentsCount,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: isWide
                              ? _WideDashboardContent(state: state)
                              : _CompactDashboardContent(state: state),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: AppSpacing.xxl),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CompactDashboardContent extends StatelessWidget {
  const _CompactDashboardContent({required this.state});

  final DoctorDashboardState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StatisticsGrid(state: state),
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

class _WideDashboardContent extends StatelessWidget {
  const _WideDashboardContent({required this.state});

  final DoctorDashboardState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StatisticsGrid(state: state),
              const SizedBox(height: AppSpacing.xl),
              const QuickActionsGrid(),
              const SizedBox(height: AppSpacing.xl),
              HealthSummaryCard(
                todayAppointmentsCount: state.todayAppointmentsCount,
                totalPatientsCount: state.totalPatientsCount,
                urgentCasesCount: state.urgentCasesCount,
                activePrescriptionsCount: state.activePrescriptionsCount,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TodayScheduleSection(appointments: state.todayAppointments),
              const SizedBox(height: AppSpacing.xl),
              RecentPatientsSection(patients: state.patients),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatisticsGrid extends StatelessWidget {
  const _StatisticsGrid({required this.state});

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
              color: const Color(0xFF2563EB),
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
