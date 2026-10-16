import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/doctor_leave.dart';
import '../../data/doctor_leave_repository.dart';
import '../data/booking_local_data_source.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key, required this.doctorId});

  final String doctorId;

  @override
  Widget build(BuildContext context) {
    final doctor = BookingLocalDataSource.doctors
        .where((item) => item.id == doctorId)
        .firstOrNull;
    final leaves = DoctorLeaveRepository().upcomingForDoctor(doctorId);

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطبيب')),
      body: doctor == null
          ? const Center(child: Text('تعذر العثور على بيانات الطبيب.'))
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.12),
                            child: Icon(doctor.icon, color: AppColors.primary),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              doctor.name,
                              style: AppTextStyles.titleMedium(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('${doctor.specialty} • ${doctor.hospital}'),
                      const SizedBox(height: AppSpacing.xs),
                      Text('${doctor.experience} • التقييم ${doctor.rating}'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('الإجازات المجدولة',
                    style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.sm),
                if (leaves.isEmpty)
                  const AppCard(
                    child: Text('لا توجد إجازات مجدولة لهذا الطبيب.'),
                  )
                else
                  ...leaves.map(
                    (leave) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _LeaveNotice(leave: leave),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _LeaveNotice extends StatelessWidget {
  const _LeaveNotice({required this.leave});

  final DoctorLeave leave;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.event_busy_rounded, color: AppColors.warning),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الطبيب في إجازة من ${DoctorLeave.formatDate(leave.startsOn)} '
                    'إلى ${DoctorLeave.formatDate(leave.endsOn)}.',
                    style: AppTextStyles.bodyMedium(context),
                  ),
                  if (leave.reason.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text('السبب: ${leave.reason}',
                        style: AppTextStyles.bodyMedium(context)),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
}
