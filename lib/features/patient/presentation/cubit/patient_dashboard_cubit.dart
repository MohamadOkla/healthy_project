import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/current_patient.dart';
import '../../../laboratory/data/repositories/laboratory_repository_impl.dart';
import '../../../laboratory/domain/repositories/laboratory_repository.dart';
import '../../../prescriptions/data/repositories/prescriptions_repository_impl.dart';
import '../../../prescriptions/domain/repositories/prescriptions_repository.dart';
import '../models/appointment_model.dart';
import '../models/health_summary_model.dart';
import '../models/quick_action_model.dart';
import 'patient_dashboard_state.dart';

class PatientDashboardCubit extends Cubit<PatientDashboardState> {
  PatientDashboardCubit({
    PrescriptionsRepository? prescriptionsRepository,
    LaboratoryRepository? laboratoryRepository,
  })  : _prescriptionsRepository =
            prescriptionsRepository ?? PrescriptionsRepositoryImpl(),
        _laboratoryRepository = laboratoryRepository ?? LaboratoryRepositoryImpl(),
        super(
          const PatientDashboardState(
            healthSummary: HealthSummaryModel(
              status: 'حالتك الصحية مستقرة',
              lastVisit: 'منذ 12 يوماً',
              score: 0.92,
              // Matches AppointmentsCubit's one confirmed appointment - see
              // the note on PatientDashboardCubit.load() for why this one
              // count isn't pulled from a shared repository yet.
              upcomingAppointments: 1,
              activePrescriptions: 0,
              newResults: 0,
            ),
            quickActions: [
              QuickActionModel(
                title: 'مواعيدي',
                icon: Icons.calendar_month_rounded,
                route: AppRoutes.patientAppointments,
              ),
              QuickActionModel(
                title: 'السجل الطبي',
                icon: Icons.assignment_rounded,
                route: AppRoutes.patientMedicalRecords,
              ),
              QuickActionModel(
                title: 'الوصفات',
                icon: Icons.medication_rounded,
                route: AppRoutes.patientPrescriptions,
              ),
              QuickActionModel(
                title: 'التحاليل',
                icon: Icons.science_rounded,
                route: AppRoutes.patientLaboratory,
              ),
            ],
            upcomingAppointment: AppointmentModel(
              doctorName: 'د. أحمد خالد',
              specialty: 'قلبية',
              day: 'الثلاثاء',
              time: '10:30 صباحاً',
            ),
          ),
        ) {
    _loadRealCounts();
  }

  final PrescriptionsRepository _prescriptionsRepository;
  final LaboratoryRepository _laboratoryRepository;

  // AppointmentsCubit currently keeps its sample appointments to itself
  // rather than behind a shared repository (see CHANGELOG), so
  // `upcomingAppointments` above is a constant kept in sync with it by hand
  // rather than computed here. Prescriptions and lab results *are* behind
  // real shared repositories, so those two are computed for real.
  void _loadRealCounts() {
    final activePrescriptions = _prescriptionsRepository
        .getPrescriptionsForPatient(currentPatientId)
        .where((prescription) => prescription.isActive)
        .length;
    final newResults = _laboratoryRepository
        .getResultsForPatient(currentPatientId)
        .length;

    emit(
      state.copyWith(
        healthSummary: state.healthSummary.copyWith(
          activePrescriptions: activePrescriptions,
          newResults: newResults,
        ),
      ),
    );
  }
}
