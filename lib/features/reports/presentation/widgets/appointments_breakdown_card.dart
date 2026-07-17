import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/reports_state.dart';
import 'report_mini_stat.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class AppointmentsBreakdownCard extends StatelessWidget {
  const AppointmentsBreakdownCard({required this.state});

  final ReportsState state;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('مواعيد اليوم حسب الحالة', style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ReportMiniStat(
                  label: 'مؤكدة',
                  value: state.confirmedAppointments,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ReportMiniStat(
                  label: 'بالانتظار',
                  value: state.waitingAppointments,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ReportMiniStat(
                  label: 'عاجلة',
                  value: state.urgentAppointments,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
