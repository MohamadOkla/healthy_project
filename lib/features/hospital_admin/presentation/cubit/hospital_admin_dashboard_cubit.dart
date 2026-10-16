import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../doctor/data/repositories/doctor_repository_impl.dart';
import '../../../doctor/domain/repositories/doctor_repository.dart';
import '../../../appointments/data/doctor_leave_repository.dart';
import '../../../patient/data/repositories/consultations_repository_impl.dart';
import '../../../patient/domain/repositories/consultations_repository.dart';
import '../../data/repositories/hospital_admin_repository_impl.dart';
import '../../domain/entities/hospital_doctor.dart';
import '../../domain/repositories/hospital_admin_repository.dart';
import 'hospital_admin_dashboard_state.dart';

class HospitalAdminDashboardCubit extends Cubit<HospitalAdminDashboardState> {
  HospitalAdminDashboardCubit({
    HospitalAdminRepository? hospitalAdminRepository,
    DoctorRepository? doctorRepository,
    ConsultationsRepository? consultationsRepository,
  })  : _hospitalAdminRepository =
            hospitalAdminRepository ?? HospitalAdminRepositoryImpl(),
        _doctorRepository = doctorRepository ?? DoctorRepositoryImpl(),
        _consultationsRepository =
            consultationsRepository ?? ConsultationsRepositoryImpl(),
        super(const HospitalAdminDashboardState()) {
    loadDashboard();
  }

  final HospitalAdminRepository _hospitalAdminRepository;
  final DoctorRepository _doctorRepository;
  final ConsultationsRepository _consultationsRepository;

  void loadDashboard() {
    final leaves = DoctorLeaveRepository(hospitals: _hospitalAdminRepository);
    final today = DateTime.now();
    final doctors = _hospitalAdminRepository.getDoctors().map((doctor) {
      final onLeave = leaves.isOnLeave(doctor.id, today);
      return doctor.copyWith(
        status: onLeave
            ? HospitalDoctorStatus.onLeave
            : HospitalDoctorStatus.active,
      );
    }).toList(growable: false);

    // Only one doctor's patient roster and schedule is modeled in this demo
    // (see DoctorRepository), so hospital-wide appointment/patient totals
    // are read from that same source rather than duplicated per doctor.
    final todayAppointments = _doctorRepository.getTodayAppointments().length;
    final totalPatients = _doctorRepository.getPatients().length;
    final pendingConsultations =
        _consultationsRepository.getPendingConsultations().length;

    emit(
      state.copyWith(
        doctors: doctors,
        todayAppointmentsCount: todayAppointments,
        totalPatientsCount: totalPatients,
        pendingConsultationsCount: pendingConsultations,
      ),
    );
  }

  void refresh() => loadDashboard();
}
