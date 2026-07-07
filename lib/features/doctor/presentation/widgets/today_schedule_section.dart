import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/doctor_appointment.dart';
import 'appointment_card.dart';

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

class TodayScheduleSection extends StatelessWidget {
  const TodayScheduleSection({super.key, required this.appointments});

  final List<DoctorAppointment> appointments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'جدول اليوم',
                style: AppTextStyles.titleMedium(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.doctorAppointments),
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (appointments.isEmpty)
          Text('لا توجد مواعيد اليوم', style: AppTextStyles.bodyMedium(context))
        else
          SizedBox(
            height: 176,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: appointments.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final (statusLabel, statusColor) =
                    _statusLabelAndColor(appointment.status);
                return GestureDetector(
                  onTap: () => context.go(
                    AppRoutes.doctorPatientDetail,
                    extra: appointment.patientId,
                  ),
                  child: AppointmentCard(
                    patientName: appointment.patientName,
                    time: appointment.time,
                    visitType: appointment.visitType,
                    status: statusLabel,
                    statusColor: statusColor,
                    initials: _initialsFor(appointment.patientName),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  String _initialsFor(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    final first = parts.first.substring(0, 1);
    if (parts.length == 1) return first;
    return '$first${parts[1].substring(0, 1)}';
  }
}
