import 'package:equatable/equatable.dart';

import '../../domain/entities/doctor_appointment.dart';
import '../../domain/entities/patient_summary.dart';

class DoctorDashboardState extends Equatable {
  const DoctorDashboardState({
    this.doctorName = 'د. سارة منصور',
    this.patients = const [],
    this.todayAppointments = const [],
    this.activePrescriptionsCount = 0,
    this.medicalRecordsCount = 0,
    this.isLoading = false,
  });

  final String doctorName;
  final List<PatientSummary> patients;
  final List<DoctorAppointment> todayAppointments;
  final int activePrescriptionsCount;
  final int medicalRecordsCount;
  final bool isLoading;

  int get totalPatientsCount => patients.length;
  int get todayAppointmentsCount => todayAppointments.length;
  int get urgentCasesCount => todayAppointments
      .where(
        (appointment) => appointment.status == DoctorAppointmentStatus.urgent,
      )
      .length;

  DoctorDashboardState copyWith({
    String? doctorName,
    List<PatientSummary>? patients,
    List<DoctorAppointment>? todayAppointments,
    int? activePrescriptionsCount,
    int? medicalRecordsCount,
    bool? isLoading,
  }) {
    return DoctorDashboardState(
      doctorName: doctorName ?? this.doctorName,
      patients: patients ?? this.patients,
      todayAppointments: todayAppointments ?? this.todayAppointments,
      activePrescriptionsCount:
          activePrescriptionsCount ?? this.activePrescriptionsCount,
      medicalRecordsCount: medicalRecordsCount ?? this.medicalRecordsCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        doctorName,
        patients,
        todayAppointments,
        activePrescriptionsCount,
        medicalRecordsCount,
        isLoading,
      ];
}
