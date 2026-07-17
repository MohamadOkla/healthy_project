import 'package:flutter/material.dart';
import '../../../doctor/presentation/widgets/statistics_card.dart';
import '../cubit/hospital_admin_dashboard_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class AdminStatsGrid extends StatelessWidget {
  const AdminStatsGrid({required this.state});

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
              color: AppColors.accentBlue,
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
