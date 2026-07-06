import '../../domain/entities/doctor_appointment.dart';
import '../../domain/entities/patient_summary.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../datasources/doctor_local_datasource.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  DoctorRepositoryImpl({DoctorLocalDataSource? dataSource})
      : _dataSource = dataSource ?? DoctorLocalDataSource.instance;

  final DoctorLocalDataSource _dataSource;

  @override
  List<PatientSummary> getPatients() => _dataSource.getPatients();

  @override
  PatientSummary? getPatientById(String patientId) =>
      _dataSource.getPatientById(patientId);

  @override
  List<DoctorAppointment> getTodayAppointments() =>
      _dataSource.getTodayAppointments();
}
