import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/appointments_cubit.dart';
import '../models/appointment_ui_model.dart';
import '../widgets/appointment_info_row.dart';
import '../widgets/appointment_status_chip.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key, this.appointment});

  final AppointmentUiModel? appointment;

  @override
  Widget build(BuildContext context) {
    final appointment =
        this.appointment ?? AppointmentsCubit.sampleAppointment;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientAppointments),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('تفاصيل الموعد'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFFE0F2F1),
                      child: Icon(
                        Icons.medical_services_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.doctorName,
                            style: AppTextStyles.titleMedium,
                          ),
                          Text(
                            appointment.specialty,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    AppointmentStatusChip(status: appointment.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                AppointmentInfoRow(
                  icon: Icons.local_hospital_rounded,
                  label: 'المشفى',
                  value: appointment.hospital,
                ),
                const SizedBox(height: AppSpacing.md),
                AppointmentInfoRow(
                  icon: Icons.apartment_rounded,
                  label: 'القسم',
                  value: appointment.department,
                ),
                const SizedBox(height: AppSpacing.md),
                AppointmentInfoRow(
                  icon: Icons.event_rounded,
                  label: 'التاريخ',
                  value: '${appointment.day}، ${appointment.date}',
                ),
                const SizedBox(height: AppSpacing.md),
                AppointmentInfoRow(
                  icon: Icons.schedule_rounded,
                  label: 'الوقت',
                  value: appointment.time,
                ),
                const SizedBox(height: AppSpacing.md),
                AppointmentInfoRow(
                  icon: Icons.confirmation_number_rounded,
                  label: 'رقم الموعد',
                  value: appointment.appointmentNumber,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ملاحظات الموعد', style: AppTextStyles.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(appointment.notes, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('تعليمات قبل الزيارة', style: AppTextStyles.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                ...appointment.instructions.map(
                  (instruction) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            instruction,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            text: 'تعديل الموعد',
            icon: Icons.edit_calendar_rounded,
            onPressed: () => context.go(AppRoutes.patientBookAppointment),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            text: 'إلغاء الموعد',
            icon: Icons.cancel_rounded,
            isOutlined: true,
            onPressed: () => _showCancelDialog(context),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الموعد'),
        content: const Text('هل أنت متأكد من رغبتك بإلغاء هذا الموعد؟'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('تراجع'),
          ),
          FilledButton(
            onPressed: () => context.pop(),
            child: const Text('تأكيد الإلغاء'),
          ),
        ],
      ),
    );
  }
}
