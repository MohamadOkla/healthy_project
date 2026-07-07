import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/book_appointment_cubit.dart';
import '../cubit/book_appointment_state.dart';
import '../widgets/booking_step_indicator.dart';
import '../widgets/specialty_filter_chip.dart';

class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key, this.cubit});

  final BookAppointmentCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final existingCubit = cubit;
    if (existingCubit != null) {
      return BlocProvider.value(
        value: existingCubit,
        child: const _BookAppointmentView(),
      );
    }

    return BlocProvider(
      create: (_) => BookAppointmentCubit(),
      child: const _BookAppointmentView(),
    );
  }
}

class _BookAppointmentView extends StatelessWidget {
  const _BookAppointmentView();

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
              _SelectionSection(
                title: 'اختر الاختصاص',
                children: BookAppointmentCubit.specialties
                    .map(
                      (specialty) => SpecialtyFilterChip(
                        label: specialty,
                        isSelected: state.selectedSpecialty == specialty,
                        onSelected: () => cubit.selectSpecialty(specialty),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              _SelectionSection(
                title: 'اختر المشفى',
                children: BookAppointmentCubit.hospitals
                    .map(
                      (hospital) => SpecialtyFilterChip(
                        label: hospital,
                        isSelected: state.selectedHospital == hospital,
                        onSelected: () => cubit.selectHospital(hospital),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              _SelectionSection(
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

class _SelectionSection extends StatelessWidget {
  const _SelectionSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.md),
          Wrap(runSpacing: AppSpacing.sm, children: children),
        ],
      ),
    );
  }
}
