import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../data/repositories/doctor_repository_impl.dart';
import '../../domain/entities/doctor_appointment.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../widgets/doctor_bottom_navigation.dart';

(String, Color) _statusLabelAndColor(DoctorAppointmentStatus status) {
  switch (status) {
    case DoctorAppointmentStatus.confirmed:
      return ('مؤكد', AppColors.success);
    case DoctorAppointmentStatus.waiting:
      return ('بالانتظار', AppColors.warning);
    case DoctorAppointmentStatus.urgent:
      return ('عاجل', AppColors.error);
    case DoctorAppointmentStatus.completed:
      return ('مكتمل', AppColors.primary);
  }
}

class DoctorAppointmentsScreen extends StatelessWidget {
  const DoctorAppointmentsScreen({super.key, this.repository});

  final DoctorRepository? repository;

  @override
  Widget build(BuildContext context) {
    final appointments =
        (repository ?? DoctorRepositoryImpl()).getTodayAppointments();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('جدول اليوم'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.doctor),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: appointments.isEmpty
          ? const AppEmptyState(
              title: 'لا توجد مواعيد اليوم',
              icon: Icons.event_available_rounded,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: appointments.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final (statusLabel, statusColor) =
                    _statusLabelAndColor(appointment.status);
                return AppCard(
                  onTap: () => context.go(
                    AppRoutes.doctorPatientDetail,
                    extra: appointment.patientId,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.patientName,
                              style: AppTextStyles.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              '${appointment.time} · ${appointment.visitType}',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Text(
                          statusLabel,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: const DoctorBottomNavigation(selectedIndex: 2),
    );
  }
}
