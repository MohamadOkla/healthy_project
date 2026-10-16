import '../../../appointments/presentation/data/booking_local_data_source.dart';
import '../../../appointments/presentation/models/doctor_ui_model.dart';
import '../../domain/entities/hospital_doctor.dart';

class HospitalAdminLocalDataSource {
  HospitalAdminLocalDataSource._();

  static final HospitalAdminLocalDataSource instance =
      HospitalAdminLocalDataSource._();

  /// The existing demo administrator dashboard represents this hospital.
  /// There is no backend or account-to-hospital association in this project.
  static const managerHospitalId = 'damascusUniversity';

  final Map<String, HospitalDoctorStatus> _statuses = {};

  List<HospitalDoctor> getDoctors() => BookingLocalDataSource.doctors
      .where((doctor) => doctor.hospitalId.name == managerHospitalId)
      .map(_toHospitalDoctor)
      .toList(growable: false);

  HospitalDoctor? getDoctorById(String doctorId) {
    final doctor = BookingLocalDataSource.doctors
        .where((doctor) => doctor.id == doctorId)
        .firstOrNull;
    if (doctor == null || doctor.hospitalId.name != managerHospitalId) {
      return null;
    }
    return _toHospitalDoctor(doctor);
  }

  void setDoctorStatus(String doctorId, HospitalDoctorStatus status) {
    if (getDoctorById(doctorId) == null) return;
    _statuses[doctorId] = status;
  }

  HospitalDoctor _toHospitalDoctor(DoctorUiModel doctor) => HospitalDoctor(
        id: doctor.id,
        hospitalId: doctor.hospitalId.name,
        name: doctor.name,
        specialty: doctor.specialty,
        phone: doctor.phone,
        email: doctor.email,
        patientsCount: _patientCounts[doctor.id] ?? 0,
        todayAppointmentsCount: _todayAppointmentCounts[doctor.id] ?? 0,
        status: _statuses[doctor.id] ?? HospitalDoctorStatus.active,
      );

  static const _patientCounts = <String, int>{
    'd1': 6,
    'd2': 21,
    'd3': 18,
    'd4': 42,
    'd5': 27,
    'd6': 34,
  };

  static const _todayAppointmentCounts = <String, int>{
    'd1': 4,
    'd2': 5,
    'd3': 0,
    'd4': 9,
    'd5': 6,
    'd6': 7,
  };
}
