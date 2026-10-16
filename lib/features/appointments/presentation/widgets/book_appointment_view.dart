import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/book_appointment_cubit.dart';
import '../cubit/book_appointment_state.dart';
import '../models/booking_ids.dart';
import 'booking_step_indicator.dart';
import 'specialty_filter_chip.dart';
import 'booking_selection_section.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';

class BookAppointmentView extends StatelessWidget {
  const BookAppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientAppointments),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('حجز موعد'),
      ),
      body: BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
        builder: (context, state) {
          final cubit = context.read<BookAppointmentCubit>();
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              const BookingStepIndicator(currentStep: 1),
              const SizedBox(height: AppSpacing.lg),
              BookingSelectionSection(
                title: 'اختر الاختصاص',
                children: BookAppointmentCubit.specialties
                    .map(
                      (specialty) => SpecialtyFilterChip(
                        label: specialty.label,
                        isSelected: state.selectedSpecialty == specialty,
                        onSelected: () => cubit.selectSpecialty(specialty),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              BookingSelectionSection(
                title: 'اختر المشفى',
                children: BookAppointmentCubit.hospitals
                    .map(
                      (hospital) => SpecialtyFilterChip(
                        label: hospital.label,
                        isSelected: state.selectedHospital == hospital,
                        onSelected: () => cubit.selectHospital(hospital),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              BookingSelectionSection(
                title: 'نوع الزيارة',
                children: BookAppointmentCubit.visitTypes
                    .map(
                      (visitType) => SpecialtyFilterChip(
                        label: visitType,
                        isSelected: state.selectedVisitType == visitType,
                        onSelected: () => cubit.selectVisitType(visitType),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                text: 'متابعة لاختيار الطبيب',
                icon: Icons.arrow_back_rounded,
                onPressed: state.canContinueFromBooking
                    ? () => context.go(
                          AppRoutes.patientSelectDoctor,
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
