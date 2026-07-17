import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/reports_state.dart';
import 'report_mini_stat.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class ConsultationsBreakdownCard extends StatelessWidget {
  const ConsultationsBreakdownCard({required this.state});

  final ReportsState state;

  @override
  Widget build(BuildContext context) {
    final total = state.totalConsultations;
    final answeredRate =
        total == 0 ? 0 : ((state.answeredConsultations / total) * 100).round();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('معدّل الرد على الاستشارات', style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ReportMiniStat(
                  label: 'تم الرد',
                  value: state.answeredConsultations,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ReportMiniStat(
                  label: 'بانتظار الرد',
                  value: state.pendingConsultations,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ReportMiniStat(
                  label: 'نسبة الرد %',
                  value: answeredRate,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
