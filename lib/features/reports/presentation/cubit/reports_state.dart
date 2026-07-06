import 'package:equatable/equatable.dart';

class SpecialtyCount extends Equatable {
  const SpecialtyCount({required this.specialty, required this.count});

  final String specialty;
  final int count;

  @override
  List<Object?> get props => [specialty, count];
}

class DoctorLoad extends Equatable {
  const DoctorLoad({required this.doctorName, required this.patientsCount});

  final String doctorName;
  final int patientsCount;

  @override
  List<Object?> get props => [doctorName, patientsCount];
}

class ReportsState extends Equatable {
  const ReportsState({
    this.doctorsBySpecialty = const [],
    this.patientLoadByDoctor = const [],
    this.confirmedAppointments = 0,
    this.waitingAppointments = 0,
    this.urgentAppointments = 0,
    this.answeredConsultations = 0,
    this.pendingConsultations = 0,
  });

  final List<SpecialtyCount> doctorsBySpecialty;
  final List<DoctorLoad> patientLoadByDoctor;
  final int confirmedAppointments;
  final int waitingAppointments;
  final int urgentAppointments;
  final int answeredConsultations;
  final int pendingConsultations;

  int get totalAppointments =>
      confirmedAppointments + waitingAppointments + urgentAppointments;
  int get totalConsultations => answeredConsultations + pendingConsultations;

  ReportsState copyWith({
    List<SpecialtyCount>? doctorsBySpecialty,
    List<DoctorLoad>? patientLoadByDoctor,
    int? confirmedAppointments,
    int? waitingAppointments,
    int? urgentAppointments,
    int? answeredConsultations,
    int? pendingConsultations,
  }) {
    return ReportsState(
      doctorsBySpecialty: doctorsBySpecialty ?? this.doctorsBySpecialty,
      patientLoadByDoctor: patientLoadByDoctor ?? this.patientLoadByDoctor,
      confirmedAppointments:
          confirmedAppointments ?? this.confirmedAppointments,
      waitingAppointments: waitingAppointments ?? this.waitingAppointments,
      urgentAppointments: urgentAppointments ?? this.urgentAppointments,
      answeredConsultations:
          answeredConsultations ?? this.answeredConsultations,
      pendingConsultations: pendingConsultations ?? this.pendingConsultations,
    );
  }

  @override
  List<Object?> get props => [
        doctorsBySpecialty,
        patientLoadByDoctor,
        confirmedAppointments,
        waitingAppointments,
        urgentAppointments,
        answeredConsultations,
        pendingConsultations,
      ];
}
