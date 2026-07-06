import '../../domain/entities/medical_record_entry.dart';
import '../../domain/repositories/medical_records_repository.dart';
import '../datasources/medical_records_local_datasource.dart';

class MedicalRecordsRepositoryImpl implements MedicalRecordsRepository {
  MedicalRecordsRepositoryImpl({MedicalRecordsLocalDataSource? dataSource})
      : _dataSource = dataSource ?? MedicalRecordsLocalDataSource.instance;

  final MedicalRecordsLocalDataSource _dataSource;

  @override
  List<MedicalRecordEntry> getRecordsForPatient(String patientId) {
    return _dataSource.getRecordsForPatient(patientId);
  }

  @override
  MedicalRecordEntry addRecord({
    required String patientId,
    required String doctorName,
    required String specialty,
    required String hospital,
    required String diagnosis,
    required String symptoms,
    required String doctorNotes,
    List<(String, String)> vitals = const [],
    List<String> medications = const [],
    List<String> testsRequired = const [],
  }) {
    return _dataSource.addRecord(
      patientId: patientId,
      doctorName: doctorName,
      specialty: specialty,
      hospital: hospital,
      diagnosis: diagnosis,
      symptoms: symptoms,
      doctorNotes: doctorNotes,
      vitals: vitals,
      medications: medications,
      testsRequired: testsRequired,
    );
  }
}
