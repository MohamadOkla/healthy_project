import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/reports_cubit.dart';
import '../cubit/reports_state.dart';
import '../widgets/bar_chart_item.dart';
import '../widgets/simple_bar_chart.dart';
import '../widgets/appointments_breakdown_card.dart';
import '../widgets/consultations_breakdown_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';

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
                                color: AppColors.accentPalette[i % AppColors.accentPalette.length],
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
                                color: AppColors.accentPalette[i % AppColors.accentPalette.length],
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppointmentsBreakdownCard(state: state),
                        const SizedBox(height: AppSpacing.md),
                        ConsultationsBreakdownCard(state: state),
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
