import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../medical_records/domain/repositories/medical_records_repository.dart';
import '../../../medical_records/data/repositories/medical_records_repository_impl.dart';
import '../../../prescriptions/domain/repositories/prescriptions_repository.dart';
import '../../../prescriptions/data/repositories/prescriptions_repository_impl.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../../data/repositories/doctor_repository_impl.dart';
import 'doctor_dashboard_state.dart';

class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  DoctorDashboardCubit({
    DoctorRepository? doctorRepository,
    PrescriptionsRepository? prescriptionsRepository,
    MedicalRecordsRepository? medicalRecordsRepository,
  })  : _doctorRepository = doctorRepository ?? DoctorRepositoryImpl(),
        _prescriptionsRepository =
            prescriptionsRepository ?? PrescriptionsRepositoryImpl(),
        _medicalRecordsRepository =
            medicalRecordsRepository ?? MedicalRecordsRepositoryImpl(),
        super(const DoctorDashboardState()) {
    loadDashboard();
  }

  final DoctorRepository _doctorRepository;
  final PrescriptionsRepository _prescriptionsRepository;
  final MedicalRecordsRepository _medicalRecordsRepository;

  void loadDashboard() {
    final patients = _doctorRepository.getPatients();
    final appointments = _doctorRepository.getTodayAppointments();

    var activePrescriptions = 0;
    var medicalRecords = 0;
    for (final patient in patients) {
      activePrescriptions += _prescriptionsRepository
          .getPrescriptionsForPatient(patient.id)
          .where((prescription) => prescription.isActive)
          .length;
      medicalRecords += _medicalRecordsRepository
          .getRecordsForPatient(patient.id)
          .length;
    }

    emit(
      state.copyWith(
        patients: patients,
        todayAppointments: appointments,
        activePrescriptionsCount: activePrescriptions,
        medicalRecordsCount: medicalRecords,
      ),
    );
  }
}
