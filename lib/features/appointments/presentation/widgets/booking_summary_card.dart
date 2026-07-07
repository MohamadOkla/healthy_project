import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/book_appointment_state.dart';
import 'appointment_info_row.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({super.key, required this.state});

  final BookAppointmentState state;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ملخص الحجز', style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.md),
          AppointmentInfoRow(
            icon: Icons.person_rounded,
            label: 'الطبيب',
            value: state.selectedDoctor?.name ?? 'غير محدد',
          ),
          const SizedBox(height: AppSpacing.sm),
          AppointmentInfoRow(
            icon: Icons.medical_services_rounded,
            label: 'الاختصاص',
            value: state.selectedSpecialty ??
                state.selectedDoctor?.specialty ??
                'غير محدد',
          ),
          const SizedBox(height: AppSpacing.sm),
          AppointmentInfoRow(
            icon: Icons.local_hospital_rounded,
            label: 'المشفى',
            value: state.selectedHospital ??
                state.selectedDoctor?.hospital ??
                'غير محدد',
          ),
          const SizedBox(height: AppSpacing.sm),
          AppointmentInfoRow(
            icon: Icons.schedule_rounded,
            label: 'الوقت',
            value: state.selectedTime ?? 'اختر الوقت',
          ),
          if (state.canConfirm) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'سيتم إرسال تذكير قبل موعد الزيارة.',
              style:
                  AppTextStyles.bodyMedium(context).copyWith(color: AppColors.primary),
            ),
          ],
        ],
      ),
    );
  }
}
