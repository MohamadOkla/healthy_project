import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
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
          final morningSlots = BookAppointmentCubit.timeSlots
              .where((slot) => slot.period == 'صباحاً')
              .toList();
          final eveningSlots = BookAppointmentCubit.timeSlots
              .where((slot) => slot.period == 'مساءً')
              .toList();

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              const BookingStepIndicator(currentStep: 3),
              const SizedBox(height: AppSpacing.lg),
              DateSelector(
                selectedDate: state.selectedDate,
                onDateSelected: cubit.selectDate,
              ),
              const SizedBox(height: AppSpacing.lg),
              TimeSlotGrid(
                title: 'الفترة الصباحية',
                slots: morningSlots,
                selectedTime: state.selectedTime,
                onSelected: cubit.selectTime,
              ),
              const SizedBox(height: AppSpacing.lg),
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
                text: 'تأكيد الحجز',
                icon: Icons.check_circle_rounded,
                onPressed: state.canConfirm
                    ? () => context.go(
                          AppRoutes.patientBookingSuccess,
                          extra: state,
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
