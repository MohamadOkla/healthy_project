import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/doctor_leave.dart';
import '../cubit/book_appointment_cubit.dart';
import '../cubit/book_appointment_state.dart';
import '../widgets/booking_step_indicator.dart';
import '../widgets/booking_summary_card.dart';
import '../widgets/date_selector.dart';
import '../widgets/time_slot_grid.dart';

class DateTimeSelectionScreen extends StatelessWidget {
  const DateTimeSelectionScreen({super.key, required this.cubit});

  final BookAppointmentCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: cubit, child: const _DateTimeSelectionView());
  }
}

class _DateTimeSelectionView extends StatelessWidget {
  const _DateTimeSelectionView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(
            AppRoutes.patientSelectDoctor,
            extra: context.read<BookAppointmentCubit>(),
          ),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('اختيار التاريخ والوقت'),
      ),
      body: BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
        builder: (context, state) {
          final cubit = context.read<BookAppointmentCubit>();
          final slots = cubit.availableSlots;
          final leaves = cubit.upcomingLeavesForSelectedDoctor;
          final selectedLeave = cubit.leaveForSelectedDate;
          final morningSlots =
              slots.where((slot) => slot.startAt.hour < 12).toList();
          final eveningSlots =
              slots.where((slot) => slot.startAt.hour >= 12).toList();

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              const BookingStepIndicator(currentStep: 3),
              const SizedBox(height: AppSpacing.lg),
              DateSelector(
                selectedDate: state.selectedDate,
                onDateSelected: cubit.selectDate,
                leaves: leaves,
              ),
              if (leaves.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('إجازات الطبيب المسجلة'),
                      const SizedBox(height: AppSpacing.xs),
                      for (final leave in leaves)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            'إجازة من ${DoctorLeave.formatDate(leave.startsOn)} إلى ${DoctorLeave.formatDate(leave.endsOn)}',
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              if (selectedLeave != null) ...[
                AppCard(
                  child: Text(
                    'الطبيب في إجازة من ${DoctorLeave.formatDate(selectedLeave.startsOn)} إلى ${DoctorLeave.formatDate(selectedLeave.endsOn)}، ولا تتوفر مواعيد خلال هذه الفترة',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (state.selectedDate != null &&
                  selectedLeave == null &&
                  !slots.any((slot) => slot.isAvailable)) ...[
                AppCard(
                    child: Column(children: [
                  const Text('لا توجد أوقات متاحة في هذا اليوم.'),
                  const SizedBox(height: AppSpacing.sm),
                  Text(cubit.nextAvailableDate() == null
                      ? 'لا توجد مواعيد لهذا الطبيب ضمن الأسبوعين القادمين.'
                      : 'يمكنك الانتقال إلى أقرب يوم متاح.'),
                  if (cubit.nextAvailableDate() != null)
                    TextButton.icon(
                        onPressed: cubit.chooseNextAvailableDate,
                        icon: const Icon(Icons.event_available_rounded),
                        label: const Text('الانتقال إلى أقرب يوم متاح')),
                ])),
              ],
              if (morningSlots.isNotEmpty)
                TimeSlotGrid(
                  title: 'الفترة الصباحية',
                  slots: morningSlots,
                  selectedTime: state.selectedTime,
                  onSelected: cubit.selectTime,
                ),
              const SizedBox(height: AppSpacing.lg),
              if (eveningSlots.isNotEmpty)
                TimeSlotGrid(
                  title: 'الفترة المسائية',
                  slots: eveningSlots,
                  selectedTime: state.selectedTime,
                  onSelected: cubit.selectTime,
                ),
              const SizedBox(height: AppSpacing.lg),
              BookingSummaryCard(state: state),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                text: 'متابعة للمراجعة',
                icon: Icons.check_circle_rounded,
                onPressed: cubit.canContinueFromDateTime
                    ? () => context.go(
                          AppRoutes.patientBookingReview,
                          extra: cubit,
                        )
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
