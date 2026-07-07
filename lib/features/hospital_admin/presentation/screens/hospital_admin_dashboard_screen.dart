import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../doctor/presentation/widgets/statistics_card.dart';
import '../cubit/hospital_admin_dashboard_cubit.dart';
import '../cubit/hospital_admin_dashboard_state.dart';
import '../widgets/hospital_admin_bottom_navigation.dart';
import '../widgets/hospital_doctor_tile.dart';

const List<Color> _accentPalette = [
  AppColors.primary,
  Color(0xFF2563EB),
  Color(0xFF7C3AED),
  Color(0xFFEA580C),
  Color(0xFF0891B2),
  AppColors.success,
];

class HospitalAdminDashboardScreen extends StatelessWidget {
  const HospitalAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HospitalAdminDashboardCubit(),
      child: const Scaffold(
        body: SafeArea(child: _DashboardBody()),
        bottomNavigationBar: HospitalAdminBottomNavigation(selectedIndex: 0),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

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
                    _Header(hospitalName: state.hospitalName),
                    const SizedBox(height: AppSpacing.xl),
                    _StatsGrid(state: state),
                    const SizedBox(height: AppSpacing.md),
                    _ReportsLinkCard(
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
                              _accentPalette[entry.key % _accentPalette.length],
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

class _Header extends StatelessWidget {
  const _Header({required this.hospitalName});

  final String hospitalName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
          ),
          child: const Icon(
            Icons.local_hospital_rounded,
            color: AppColors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hospitalName,
                style: AppTextStyles.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'نظرة عامة على نشاط المشفى اليوم',
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.state});

  final HospitalAdminDashboardState state;

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
              title: 'إجمالي الأطباء',
              value: '${state.totalDoctorsCount}',
              icon: Icons.medical_services_rounded,
              color: AppColors.primary,
            ),
            StatisticsCard(
              title: 'أطباء نشطون',
              value: '${state.activeDoctorsCount}',
              icon: Icons.verified_user_rounded,
              color: AppColors.success,
            ),
            StatisticsCard(
              title: 'مواعيد اليوم',
              value: '${state.todayAppointmentsCount}',
              icon: Icons.calendar_today_rounded,
              color: const Color(0xFF2563EB),
            ),
            StatisticsCard(
              title: 'استشارات معلّقة',
              value: '${state.pendingConsultationsCount}',
              icon: Icons.forum_rounded,
              color: AppColors.warning,
            ),
          ],
        );
      },
    );
  }
}

class _ReportsLinkCard extends StatelessWidget {
  const _ReportsLinkCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(Icons.bar_chart_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('التقارير', style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: 2),
                Text(
                  'توزيع الأطباء، أعداد المرضى، ومعدل الرد على الاستشارات',
                  style: AppTextStyles.bodyMedium(context),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
        ],
      ),
    );
  }
}
