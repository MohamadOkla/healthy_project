import 'package:equatable/equatable.dart';

import '../../domain/entities/hospital_doctor.dart';

class HospitalAdminDashboardState extends Equatable {
  const HospitalAdminDashboardState({
    this.hospitalName = 'مشفى دمشق الجامعي',
    this.doctors = const [],
    this.todayAppointmentsCount = 0,
    this.totalPatientsCount = 0,
    this.pendingConsultationsCount = 0,
  });

  final String hospitalName;
  final List<HospitalDoctor> doctors;
  final int todayAppointmentsCount;
  final int totalPatientsCount;
  final int pendingConsultationsCount;

  int get totalDoctorsCount => doctors.length;
  int get activeDoctorsCount =>
      doctors.where((doctor) => doctor.status == HospitalDoctorStatus.active).length;

  HospitalAdminDashboardState copyWith({
    String? hospitalName,
    List<HospitalDoctor>? doctors,
    int? todayAppointmentsCount,
    int? totalPatientsCount,
    int? pendingConsultationsCount,
  }) {
    return HospitalAdminDashboardState(
      hospitalName: hospitalName ?? this.hospitalName,
      doctors: doctors ?? this.doctors,
      todayAppointmentsCount:
          todayAppointmentsCount ?? this.todayAppointmentsCount,
      totalPatientsCount: totalPatientsCount ?? this.totalPatientsCount,
      pendingConsultationsCount:
          pendingConsultationsCount ?? this.pendingConsultationsCount,
    );
  }

  @override
  List<Object?> get props => [
        hospitalName,
        doctors,
        todayAppointmentsCount,
        totalPatientsCount,
        pendingConsultationsCount,
      ];
}
