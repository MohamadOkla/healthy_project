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
import '../cubit/book_appointment_cubit.dart';
import '../models/appointment_ui_model.dart';
import '../../data/calendar_event_service.dart';
import '../widgets/appointment_info_row.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key, required this.booking});

  final AppointmentUiModel? booking;

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
              'تم حفظ الحجز التجريبي',
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineLarge(context),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'هذا الحجز محفوظ محلياً ولا يمثل تأكيداً من مشفى حقيقي.',
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
                    value: booking?.doctorName ?? 'غير محدد',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppointmentInfoRow(
                    icon: Icons.medical_services_rounded,
                    label: 'الاختصاص',
                    value: booking?.specialty ?? 'غير محدد',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppointmentInfoRow(
                    icon: Icons.local_hospital_rounded,
                    label: 'المشفى',
                    value: booking?.hospital ?? 'غير محدد',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppointmentInfoRow(
                    icon: Icons.medical_information_rounded,
                    label: 'نوع الزيارة',
                    value: booking?.visitType ?? 'غير محدد',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppointmentInfoRow(
                    icon: Icons.event_rounded,
                    label: 'التاريخ',
                    value: booking?.date ?? 'غير محدد',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppointmentInfoRow(
                    icon: Icons.schedule_rounded,
                    label: 'الوقت',
                    value: booking?.time ?? 'غير محدد',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
                text: 'إضافة إلى التقويم',
                icon: Icons.event_available_rounded,
                isOutlined: true,
                onPressed: booking == null
                    ? null
                    : () => _addToCalendar(context, booking!)),
            const SizedBox(height: AppSpacing.sm),
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

  Future<void> _addToCalendar(
      BuildContext context, AppointmentUiModel appointment) async {
    final start = appointment.startAt;
    if (start == null) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final status = await addAppointmentToCalendar(appointment);
      if (!context.mounted) return;
      messenger
          .showSnackBar(SnackBar(content: Text(calendarEventFeedback(status))));
    } on Object {
      if (context.mounted) {
        messenger.showSnackBar(const SnackBar(
            content:
                Text('تعذر فتح تطبيق التقويم. تحقق من توفره وحاول مرة أخرى.')));
      }
    }
  }
}
