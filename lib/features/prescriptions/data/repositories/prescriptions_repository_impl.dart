import '../../domain/entities/prescription_entry.dart';
import '../../domain/repositories/prescriptions_repository.dart';
import '../datasources/prescriptions_local_datasource.dart';

class PrescriptionsRepositoryImpl implements PrescriptionsRepository {
  PrescriptionsRepositoryImpl({PrescriptionsLocalDataSource? dataSource})
      : _dataSource = dataSource ?? PrescriptionsLocalDataSource.instance;

  final PrescriptionsLocalDataSource _dataSource;

  @override
  List<PrescriptionEntry> getPrescriptionsForPatient(String patientId) {
    return _dataSource.getPrescriptionsForPatient(patientId);
  }

  @override
  PrescriptionEntry addPrescription({
    required String patientId,
    String? doctorId,
    required String doctorName,
    required String expiryDate,
    required List<PrescriptionMedicine> medicines,
    required String notes,
    String warnings = '',
  }) {
    return _dataSource.addPrescription(
      patientId: patientId,
      doctorId: doctorId,
      doctorName: doctorName,
      expiryDate: expiryDate,
      medicines: medicines,
      notes: notes,
      warnings: warnings,
    );
  }
}
