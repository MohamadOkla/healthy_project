import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/hospital_admin_dashboard_cubit.dart';
import '../cubit/hospital_admin_dashboard_state.dart';
import 'hospital_doctor_tile.dart';
import 'admin_dashboard_header.dart';
import 'admin_stats_grid.dart';
import 'reports_link_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class AdminDashboardBody extends StatelessWidget {
  const AdminDashboardBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HospitalAdminDashboardCubit, HospitalAdminDashboardState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth >= 900 ? 900.0 : 680.0;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    AdminDashboardHeader(hospitalName: state.hospitalName),
                    const SizedBox(height: AppSpacing.xl),
                    AdminStatsGrid(state: state),
                    const SizedBox(height: AppSpacing.md),
                    ReportsLinkCard(
                      onTap: () => context.go(AppRoutes.hospitalAdminReports),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'الأطباء',
                            style: AppTextStyles.titleMedium(context).copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.go(AppRoutes.hospitalAdminDoctors),
                          child: const Text('عرض الكل'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...state.doctors.take(4).toList().asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: HospitalDoctorTile(
                          doctor: entry.value,
                          accentColor:
                              AppColors.accentPalette[entry.key % AppColors.accentPalette.length],
                          onTap: () => context.go(
                            AppRoutes.hospitalAdminDoctorDetail,
                            extra: entry.value.id,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
