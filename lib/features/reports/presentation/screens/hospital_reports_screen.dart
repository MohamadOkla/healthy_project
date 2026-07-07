import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/reports_cubit.dart';
import '../cubit/reports_state.dart';
import '../widgets/simple_bar_chart.dart';

const List<Color> _palette = [
  AppColors.primary,
  Color(0xFF2563EB),
  Color(0xFF7C3AED),
  Color(0xFFEA580C),
  Color(0xFF0891B2),
  AppColors.success,
];

class HospitalReportsScreen extends StatelessWidget {
  const HospitalReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportsCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التقارير'),
          leading: IconButton(
            tooltip: 'رجوع',
            onPressed: () => context.go(AppRoutes.hospitalAdmin),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        body: BlocBuilder<ReportsCubit, ReportsState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth >= 900 ? 900.0 : 680.0;
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: ListView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      children: [
                        SimpleBarChart(
                          title: 'توزّع الأطباء حسب الاختصاص',
                          bars: [
                            for (var i = 0;
                                i < state.doctorsBySpecialty.length;
                                i++)
                              BarChartItem(
                                label: state.doctorsBySpecialty[i].specialty,
                                value: state.doctorsBySpecialty[i].count,
                                color: _palette[i % _palette.length],
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SimpleBarChart(
                          title: 'عدد المرضى لكل طبيب',
                          bars: [
                            for (var i = 0;
                                i < state.patientLoadByDoctor.length;
                                i++)
                              BarChartItem(
                                label: state.patientLoadByDoctor[i].doctorName,
                                value: state.patientLoadByDoctor[i].patientsCount,
                                color: _palette[i % _palette.length],
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _AppointmentsBreakdownCard(state: state),
                        const SizedBox(height: AppSpacing.md),
                        _ConsultationsBreakdownCard(state: state),
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

class _AppointmentsBreakdownCard extends StatelessWidget {
  const _AppointmentsBreakdownCard({required this.state});

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
                child: _MiniStat(
                  label: 'مؤكدة',
                  value: state.confirmedAppointments,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MiniStat(
                  label: 'بالانتظار',
                  value: state.waitingAppointments,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MiniStat(
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

class _ConsultationsBreakdownCard extends StatelessWidget {
  const _ConsultationsBreakdownCard({required this.state});

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
                child: _MiniStat(
                  label: 'تم الرد',
                  value: state.answeredConsultations,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MiniStat(
                  label: 'بانتظار الرد',
                  value: state.pendingConsultations,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MiniStat(
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

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: AppTextStyles.headlineLarge(context).copyWith(color: color),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium(context).copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
