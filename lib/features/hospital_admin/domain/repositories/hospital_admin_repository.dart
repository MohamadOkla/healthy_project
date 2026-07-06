import '../entities/hospital_doctor.dart';

abstract interface class HospitalAdminRepository {
  List<HospitalDoctor> getDoctors();

  HospitalDoctor? getDoctorById(String doctorId);

  void setDoctorStatus(String doctorId, HospitalDoctorStatus status);
}
