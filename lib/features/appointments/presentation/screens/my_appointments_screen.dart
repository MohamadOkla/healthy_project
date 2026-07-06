import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../patient/presentation/widgets/patient_bottom_navigation.dart';
import '../cubit/appointments_cubit.dart';
import '../cubit/appointments_state.dart';
import '../models/appointment_status.dart';
import '../widgets/appointment_card.dart';
import '../widgets/appointment_stats_card.dart';
import '../widgets/appointment_tabs.dart';
import '../widgets/appointments_header.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppointmentsCubit(),
      child: const _MyAppointmentsView(),
    );
  }
}

class _MyAppointmentsView extends StatelessWidget {
  const _MyAppointmentsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientDashboard),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('مواعيدي'),
        actions: [
          IconButton(
            tooltip: 'بحث',
            onPressed: () => _showAppointmentSearch(context),
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            tooltip: 'تصفية',
            onPressed: () => _showAppointmentFilter(context),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: BlocBuilder<AppointmentsCubit, AppointmentsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              const AppointmentsHeader(),
              const SizedBox(height: AppSpacing.md),
              AppointmentStatsCard(
                upcoming: state.upcomingCount,
                previous: state.previousCount,
                canceled: state.canceledCount,
              ),
              const SizedBox(height: AppSpacing.md),
              AppointmentTabs(
                selectedStatus: state.selectedStatus,
                onChanged: context.read<AppointmentsCubit>().changeStatus,
              ),
              if (state.searchQuery.isNotEmpty ||
                  state.specialtyFilter != null ||
                  state.dateFilter != null) ...[
                const SizedBox(height: AppSpacing.sm),
                _ActiveFiltersSummary(state: state),
              ],
              const SizedBox(height: AppSpacing.md),
              if (state.visibleAppointments.isEmpty)
                const AppEmptyState(
                  title: 'لا توجد مواعيد',
                  message: 'غيّر البحث أو الفلترة لعرض نتائج أخرى.',
                  icon: Icons.event_busy_rounded,
                )
              else
                ...state.visibleAppointments.map(
                  (appointment) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AppointmentCard(
                      appointment: appointment,
                      onDetailsPressed: () => context.go(
                        AppRoutes.patientAppointmentDetails,
                        extra: appointment,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.patientBookAppointment),
        icon: const Icon(Icons.add_rounded),
        label: const Text('حجز موعد جديد'),
      ),
      bottomNavigationBar: const PatientBottomNavigation(selectedIndex: 1),
    );
  }

  void _showAppointmentSearch(BuildContext context) {
    final cubit = context.read<AppointmentsCubit>();
    final controller = TextEditingController(text: cubit.state.searchQuery);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: AppSpacing.lg,
              bottom:
                  MediaQuery.viewInsetsOf(sheetContext).bottom + AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'بحث في المواعيد',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: controller,
                  hint: 'اسم الطبيب، الاختصاص، أو المشفى',
                  prefixIcon: const Icon(Icons.search_rounded),
                  onChanged: cubit.searchAppointments,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'مسح البحث',
                        isOutlined: true,
                        onPressed: () {
                          controller.clear();
                          cubit.searchAppointments('');
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppButton(
                        text: 'تم',
                        onPressed: () => sheetContext.pop(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(controller.dispose);
  }

  void _showAppointmentFilter(BuildContext context) {
    final cubit = context.read<AppointmentsCubit>();
    var selectedStatus = cubit.state.selectedStatus;
    var selectedSpecialty = cubit.state.specialtyFilter;
    var selectedDate = cubit.state.dateFilter;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'تصفية المواعيد',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<AppointmentStatus>(
                      initialValue: selectedStatus,
                      decoration: const InputDecoration(labelText: 'الحالة'),
                      items: AppointmentStatus.values
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setSheetState(() => selectedStatus = value);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String?>(
                      initialValue: selectedSpecialty,
                      decoration: const InputDecoration(labelText: 'الاختصاص'),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('كل الاختصاصات'),
                        ),
                        ...cubit.specialties.map(
                          (specialty) => DropdownMenuItem<String?>(
                            value: specialty,
                            child: Text(specialty),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setSheetState(() => selectedSpecialty = value);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String?>(
                      initialValue: selectedDate,
                      decoration: const InputDecoration(labelText: 'التاريخ'),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('كل التواريخ'),
                        ),
                        ...cubit.dates.map(
                          (date) => DropdownMenuItem<String?>(
                            value: date,
                            child: Text(date),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setSheetState(() => selectedDate = value);
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'مسح الفلتر',
                            isOutlined: true,
                            onPressed: () {
                              cubit.clearFilters();
                              sheetContext.pop();
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppButton(
                            text: 'تطبيق الفلتر',
                            onPressed: () {
                              cubit.applyFilters(
                                status: selectedStatus,
                                specialty: selectedSpecialty,
                                date: selectedDate,
                              );
                              sheetContext.pop();
                            },
                          ),
                        ),
                      ],
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

class _ActiveFiltersSummary extends StatelessWidget {
  const _ActiveFiltersSummary({required this.state});

  final AppointmentsState state;

  @override
  Widget build(BuildContext context) {
    final labels = [
      if (state.searchQuery.isNotEmpty) 'بحث: ${state.searchQuery}',
      if (state.specialtyFilter != null) 'اختصاص: ${state.specialtyFilter}',
      if (state.dateFilter != null) 'تاريخ: ${state.dateFilter}',
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: labels
          .map(
            (label) => Chip(
              label: Text(label),
              backgroundColor: AppColors.primary.withValues(alpha: 0.10),
            ),
          )
          .toList(),
    );
  }
}
