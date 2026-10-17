import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/patient_dashboard_cubit.dart';
import '../cubit/patient_dashboard_state.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/health_summary_card.dart';
import '../widgets/patient_bottom_navigation.dart';
import '../widgets/patient_drawer.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_activity_section.dart';
import '../widgets/recent_results_section.dart';
import '../widgets/upcoming_appointment_card.dart';

class PatientDashboardScreen extends StatelessWidget {
  const PatientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientDashboardCubit(),
      child: const _PatientDashboardView(),
    );
  }
}

class _PatientDashboardView extends StatelessWidget {
  const _PatientDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const PatientDrawer(),
      bottomNavigationBar: const PatientBottomNavigation(selectedIndex: 0),
      body: SafeArea(
        child: BlocBuilder<PatientDashboardCubit, PatientDashboardState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth =
                    constraints.maxWidth >= 700 ? 620.0 : double.infinity;
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.sm,
                            AppSpacing.lg,
                            AppSpacing.lg,
                          ),
                          sliver: SliverList.list(
                            children: [
                              const DashboardHeader(),
                              const SizedBox(height: AppSpacing.lg),
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.94, end: 1),
                                duration: const Duration(milliseconds: 420),
                                curve: Curves.easeOut,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.scale(
                                      scale: value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: HealthSummaryCard(
                                  summary: state.healthSummary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              Text(
                                'الخدمات السريعة',
                                style: AppTextStyles.titleMedium(context),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              QuickActionsGrid(actions: state.quickActions),
                              const SizedBox(height: AppSpacing.xl),
                              UpcomingAppointmentCard(
                                appointment: state.upcomingAppointment,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              const RecentResultsSection(),
                              const SizedBox(height: AppSpacing.lg),
                              const RecentActivitySection(),
                              const SizedBox(height: AppSpacing.xxl),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
