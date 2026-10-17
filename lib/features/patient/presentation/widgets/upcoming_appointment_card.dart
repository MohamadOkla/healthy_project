import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../models/appointment_model.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  const UpcomingAppointmentCard({super.key, required this.appointment});

  final AppointmentModel? appointment;

  @override
  Widget build(BuildContext context) {
    final upcoming = appointment;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الموعد القادم', style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.md),
          if (upcoming == null) ...[
            Text(
              'لا يوجد لديك موعد قادم حاليًا.',
              style: AppTextStyles.bodyMedium(context),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              text: 'حجز موعد',
              isOutlined: true,
              onPressed: () => context.go(AppRoutes.patientBookAppointment),
            ),
          ] else ...[
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.primaryTint,
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
                      Text(upcoming.doctorName,
                          style: AppTextStyles.titleMedium(context)),
                      Text(upcoming.specialty,
                          style: AppTextStyles.bodyMedium(context)),
                      Text(upcoming.hospital,
                          style: AppTextStyles.bodyMedium(context)),
                    ],
                  ),
                ),
                Text(
                  '${upcoming.day}\n${upcoming.date}\n${upcoming.time}',
                  style: AppTextStyles.bodyMedium(context),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              text: 'عرض التفاصيل',
              isOutlined: true,
              onPressed: () => context.go(
                AppRoutes.patientAppointmentDetails,
                extra: upcoming.appointment,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
