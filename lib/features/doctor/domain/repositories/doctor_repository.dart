import '../entities/doctor_appointment.dart';
import '../entities/patient_summary.dart';

abstract interface class DoctorRepository {
  List<PatientSummary> getPatients();

  PatientSummary? getPatientById(String patientId);

  List<DoctorAppointment> getTodayAppointments();
}
