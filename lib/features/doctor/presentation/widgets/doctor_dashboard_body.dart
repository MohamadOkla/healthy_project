import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/doctor_dashboard_cubit.dart';
import '../cubit/doctor_dashboard_state.dart';
import 'doctor_dashboard_header.dart';
import 'compact_dashboard_content.dart';
import 'wide_dashboard_content.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class DoctorDashboardBody extends StatelessWidget {
  const DoctorDashboardBody();

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
                              ? WideDashboardContent(state: state)
                              : CompactDashboardContent(state: state),
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
