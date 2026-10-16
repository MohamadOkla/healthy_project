import '../../domain/entities/hospital_doctor.dart';
import '../../domain/repositories/hospital_admin_repository.dart';
import '../datasources/hospital_admin_local_datasource.dart';

class HospitalAdminRepositoryImpl implements HospitalAdminRepository {
  HospitalAdminRepositoryImpl({HospitalAdminLocalDataSource? dataSource})
      : _dataSource = dataSource ?? HospitalAdminLocalDataSource.instance;

  final HospitalAdminLocalDataSource _dataSource;

  @override
  String get currentHospitalId =>
      HospitalAdminLocalDataSource.managerHospitalId;

  @override
  List<HospitalDoctor> getDoctors() => _dataSource.getDoctors();

  @override
  HospitalDoctor? getDoctorById(String doctorId) =>
      _dataSource.getDoctorById(doctorId);

  @override
  void setDoctorStatus(String doctorId, HospitalDoctorStatus status) {
    _dataSource.setDoctorStatus(doctorId, status);
  }
}
