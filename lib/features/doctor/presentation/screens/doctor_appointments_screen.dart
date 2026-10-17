import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../appointments/data/local_appointments_repository.dart';
import '../../../appointments/presentation/cubit/appointments_cubit.dart';
import '../../../appointments/presentation/cubit/appointments_state.dart';
import '../../../appointments/presentation/models/appointment_status.dart';
import '../../../appointments/presentation/models/appointment_ui_model.dart';
import '../../data/repositories/doctor_messaging_repository.dart';
import '../widgets/doctor_bottom_navigation.dart';

class DoctorAppointmentsScreen extends StatelessWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AppointmentsCubit(
          repository: LocalAppointmentsRepository(),
        ),
        child: _DoctorAppointmentsView(
          doctorId: DoctorMessagingRepository().currentDoctorId,
        ),
      );
}

class _DoctorAppointmentsView extends StatelessWidget {
  const _DoctorAppointmentsView({required this.doctorId});

  final String doctorId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('مواعيد الطبيب'),
          leading: IconButton(
            tooltip: 'رجوع',
            onPressed: () => context.go(AppRoutes.doctor),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        body: BlocBuilder<AppointmentsCubit, AppointmentsState>(
          builder: (context, state) {
            final now = DateTime.now();
            final local = state.appointments
                .where((appointment) =>
                    appointment.doctorId == doctorId &&
                    appointment.startAt != null &&
                    appointment.startAt!.isAfter(now))
                .toList()
              ..sort((a, b) => a.startAt!.compareTo(b.startAt!));
            if (local.isEmpty) {
              return const AppEmptyState(
                title: 'لا توجد مواعيد قادمة',
                icon: Icons.event_available_rounded,
              );
            }
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                ...local.map((appointment) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _LocalAppointmentCard(
                        appointment: appointment,
                        onPatientTap: () => context.go(
                          AppRoutes.doctorPatientDetail,
                          extra: appointment.patientId,
                        ),
                      ),
                    )),
              ],
            );
          },
        ),
        bottomNavigationBar: const DoctorBottomNavigation(selectedIndex: 2),
      );
}

class _LocalAppointmentCard extends StatelessWidget {
  const _LocalAppointmentCard(
      {required this.appointment, required this.onPatientTap});

  final AppointmentUiModel appointment;
  final VoidCallback onPatientTap;

  @override
  Widget build(BuildContext context) {
    final canceled = appointment.status == AppointmentStatus.canceledByDoctor ||
        appointment.status == AppointmentStatus.canceled;
    final statusColor = canceled
        ? AppColors.error
        : appointment.status == AppointmentStatus.completed
            ? AppColors.primary
            : AppColors.success;
    return AppCard(
      onTap: onPatientTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(
                child: Text(appointment.patientName,
                    style: AppTextStyles.titleMedium(context))),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(appointment.status.label,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12)),
            ),
          ]),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${appointment.specialty} · ${appointment.hospital}',
            style: AppTextStyles.bodyMedium(context),
          ),
          Text(
              '${appointment.day}، ${appointment.date} · ${appointment.time} · ${appointment.visitType}',
              style: AppTextStyles.bodyMedium(context)),
          if (appointment.status == AppointmentStatus.confirmed &&
              appointment.startAt != null &&
              appointment.startAt!.isAfter(DateTime.now())) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: () => _confirmCancellation(context),
                icon: const Icon(Icons.event_busy_rounded),
                label: const Text('إلغاء الموعد'),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmCancellation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد إلغاء الموعد'),
        content: Text(
            'هل تريد إلغاء موعد ${appointment.patientName} في ${appointment.date} الساعة ${appointment.time}؟'),
        actions: [
          TextButton(
              onPressed: () => dialogContext.pop(false),
              child: const Text('عودة')),
          FilledButton(
              onPressed: () => dialogContext.pop(true),
              child: const Text('تأكيد الإلغاء')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      final saved = await context
          .read<AppointmentsCubit>()
          .cancelByDoctor(appointment.id, appointment.doctorId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(saved
            ? 'تم إلغاء الموعد وحفظ الحالة.'
            : 'تعذر إلغاء الموعد؛ ربما أُلغي أو اكتمل مسبقًا.'),
      ));
    } on Object {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تعذر حفظ الإلغاء. حاول مرة أخرى.')));
      }
    }
  }
}
