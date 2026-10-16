import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/book_appointment_cubit.dart';
import '../cubit/book_appointment_state.dart';
import '../models/booking_ids.dart';
import '../widgets/appointment_info_row.dart';
import '../widgets/booking_step_indicator.dart';

class BookingReviewScreen extends StatelessWidget {
  const BookingReviewScreen({super.key, required this.cubit});
  final BookAppointmentCubit cubit;

  @override
  Widget build(BuildContext context) =>
      BlocProvider.value(value: cubit, child: const _ReviewView());
}

class _ReviewView extends StatelessWidget {
  const _ReviewView();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('مراجعة الحجز'),
            leading: IconButton(
                onPressed: () => context.go(AppRoutes.patientSelectDateTime,
                    extra: context.read<BookAppointmentCubit>()),
                icon: const Icon(Icons.arrow_back_rounded))),
        body: BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
            builder: (context, state) {
          final cubit = context.read<BookAppointmentCubit>();
          if (!cubit.canContinueFromDateTime) {
            return const Center(
                child: Text(
                    'بيانات الموعد غير مكتملة. ارجع لاختيار التاريخ والوقت.'));
          }
          return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                const BookingStepIndicator(currentStep: 4),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                    child: Column(children: [
                  _row(
                      context,
                      'المشفى',
                      state.selectedHospital!.label,
                      Icons.local_hospital_rounded,
                      () => context.go(AppRoutes.patientBookAppointment,
                          extra: cubit)),
                  _row(
                      context,
                      'الاختصاص',
                      state.selectedSpecialty!.label,
                      Icons.medical_services_rounded,
                      () => context.go(AppRoutes.patientBookAppointment,
                          extra: cubit)),
                  _row(
                      context,
                      'نوع الزيارة',
                      state.selectedVisitType!,
                      Icons.medical_information_rounded,
                      () => context.go(AppRoutes.patientBookAppointment,
                          extra: cubit)),
                  _row(
                      context,
                      'الطبيب',
                      state.selectedDoctor!.name,
                      Icons.person_rounded,
                      () => context.go(AppRoutes.patientSelectDoctor,
                          extra: cubit)),
                  _row(
                      context,
                      'التاريخ',
                      '${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}',
                      Icons.event_rounded,
                      () => context.go(AppRoutes.patientSelectDateTime,
                          extra: cubit)),
                  _row(
                      context,
                      'الوقت',
                      '${state.selectedTime!.hour.toString().padLeft(2, '0')}:${state.selectedTime!.minute.toString().padLeft(2, '0')}',
                      Icons.schedule_rounded,
                      () => context.go(AppRoutes.patientSelectDateTime,
                          extra: cubit)),
                ])),
                const SizedBox(height: AppSpacing.md),
                const AppCard(
                    child: Text(
                        'هذا حجز تجريبي محفوظ على جهازك، ولا يمثل تأكيداً من مشفى حقيقي.')),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                    text: 'تأكيد الحجز التجريبي',
                    icon: Icons.check_circle_rounded,
                    isLoading: state.isConfirming,
                    onPressed: state.canConfirm
                        ? () async {
                            try {
                              final appointment = await cubit.confirmBooking();
                              if (appointment != null && context.mounted) {
                                context.go(AppRoutes.patientBookingSuccess,
                                    extra: appointment);
                              } else if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'أصبح هذا الوقت غير متاح. اختر وقتاً آخر.')));
                              }
                            } on Object {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'تعذر حفظ الموعد محلياً. حاول مرة أخرى.')));
                              }
                            }
                          }
                        : null),
              ]);
        }),
      );

  Widget _row(BuildContext context, String label, String value, IconData icon,
          VoidCallback edit) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(children: [
          Expanded(
              child:
                  AppointmentInfoRow(icon: icon, label: label, value: value)),
          TextButton.icon(
              onPressed: edit,
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text('تعديل'))
        ]),
      );
}
