import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../models/appointment_ui_model.dart';
import 'appointment_status_chip.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onDetailsPressed,
  });

  final AppointmentUiModel appointment;
  final VoidCallback onDetailsPressed;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: const Icon(
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
                      style: AppTextStyles.titleMedium(context),
                    ),
                    Text(
                      '${appointment.specialty} • ${appointment.hospital}',
                      style: AppTextStyles.bodyMedium(context),
                    ),
                  ],
                ),
              ),
              AppointmentStatusChip(status: appointment.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.event_rounded,
                color: context.colors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '${appointment.day}، ${appointment.date}',
                  style: AppTextStyles.bodyMedium(context),
                ),
              ),
              Icon(
                Icons.schedule_rounded,
                color: context.colors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(appointment.time, style: AppTextStyles.bodyMedium(context)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton.tonalIcon(
              onPressed: onDetailsPressed,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('عرض التفاصيل'),
            ),
          ),
        ],
      ),
    );
  }
}
