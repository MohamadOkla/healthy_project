import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/book_appointment_state.dart';
import '../cubit/book_appointment_cubit.dart';
import '../widgets/appointment_info_row.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key, required this.booking});

  final BookAppointmentState booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const SizedBox(height: AppSpacing.xxl),
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 64,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'تم حجز الموعد بنجاح',
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineLarge(context),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'تم تأكيد موعدك وسيتم إرسال تذكير قبل الموعد.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(context),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              child: Column(
                children: [
                  AppointmentInfoRow(
                    icon: Icons.person_rounded,
                    label: 'الطبيب',
                    value: booking.selectedDoctor?.name ?? 'غير محدد',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppointmentInfoRow(
                    icon: Icons.medical_services_rounded,
                    label: 'الاختصاص',
                    value: booking.selectedDoctor?.specialty ??
                        booking.selectedSpecialty ??
                        'غير محدد',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppointmentInfoRow(
                    icon: Icons.local_hospital_rounded,
                    label: 'المشفى',
                    value: booking.selectedDoctor?.hospital ??
                        booking.selectedHospital ??
                        'غير محدد',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppointmentInfoRow(
                    icon: Icons.medical_information_rounded,
                    label: 'نوع الزيارة',
                    value: booking.selectedVisitType ?? 'غير محدد',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppointmentInfoRow(
                    icon: Icons.event_rounded,
                    label: 'التاريخ',
                    value: _formatDate(booking.selectedDate),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppointmentInfoRow(
                    icon: Icons.schedule_rounded,
                    label: 'الوقت',
                    value: booking.selectedTime ?? 'غير محدد',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              text: 'عرض مواعيدي',
              icon: Icons.calendar_month_rounded,
              onPressed: () {
                context.read<BookAppointmentCubit>().resetBooking();
                context.go(AppRoutes.patientAppointments);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              text: 'العودة للرئيسية',
              icon: Icons.home_rounded,
              isOutlined: true,
              onPressed: () {
                context.read<BookAppointmentCubit>().resetBooking();
                context.go(AppRoutes.patientDashboard);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'غير محدد';
    }
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}
