import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/current_patient.dart';
import '../../../doctor/data/repositories/doctor_repository_impl.dart';
import '../../../doctor/domain/entities/doctor_appointment.dart';
import '../../../doctor/domain/repositories/doctor_repository.dart';
import '../../../hospital_admin/data/repositories/hospital_admin_repository_impl.dart';
import '../../../hospital_admin/domain/repositories/hospital_admin_repository.dart';
import '../../../patient/data/repositories/consultations_repository_impl.dart';
import '../../../patient/domain/entities/consultation.dart';
import '../../../patient/domain/repositories/consultations_repository.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit({
    HospitalAdminRepository? hospitalAdminRepository,
    DoctorRepository? doctorRepository,
    ConsultationsRepository? consultationsRepository,
  })  : _hospitalAdminRepository =
            hospitalAdminRepository ?? HospitalAdminRepositoryImpl(),
        _doctorRepository = doctorRepository ?? DoctorRepositoryImpl(),
        _consultationsRepository =
            consultationsRepository ?? ConsultationsRepositoryImpl(),
        super(const ReportsState()) {
    loadReports();
  }

  final HospitalAdminRepository _hospitalAdminRepository;
  final DoctorRepository _doctorRepository;
  final ConsultationsRepository _consultationsRepository;

  void loadReports() {
    final doctors = _hospitalAdminRepository.getDoctors();
    final specialtyCounts = <String, int>{};
    for (final doctor in doctors) {
      specialtyCounts.update(
        doctor.specialty,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    final doctorsBySpecialty = specialtyCounts.entries
        .map((entry) => SpecialtyCount(specialty: entry.key, count: entry.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));

    final patientLoad = doctors
        .map(
          (doctor) => DoctorLoad(
            doctorName: doctor.name,
            patientsCount: doctor.patientsCount,
          ),
        )
        .toList()
      ..sort((a, b) => b.patientsCount.compareTo(a.patientsCount));

    final appointments = _doctorRepository.getTodayAppointments();
    final confirmed = appointments
        .where((a) => a.status == DoctorAppointmentStatus.confirmed)
        .length;
    final waiting = appointments
        .where((a) => a.status == DoctorAppointmentStatus.waiting)
        .length;
    final urgent = appointments
        .where((a) => a.status == DoctorAppointmentStatus.urgent)
        .length;

    // Only one patient account exists in this demo (see currentPatientId),
    // so its consultations are the hospital's full consultation history.
    final consultations =
        _consultationsRepository.getConsultationsForPatient(currentPatientId);
    final answered = consultations
        .where((c) => c.status == ConsultationStatus.answered)
        .length;
    final pending = consultations
        .where((c) => c.status == ConsultationStatus.pending)
        .length;

    emit(
      state.copyWith(
        doctorsBySpecialty: doctorsBySpecialty,
        patientLoadByDoctor: patientLoad,
        confirmedAppointments: confirmed,
        waitingAppointments: waiting,
        urgentAppointments: urgent,
        answeredConsultations: answered,
        pendingConsultations: pending,
      ),
    );
  }
}
