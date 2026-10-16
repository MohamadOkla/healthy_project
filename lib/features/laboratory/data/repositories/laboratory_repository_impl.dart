import '../../domain/entities/lab_result_entry.dart';
import '../../domain/repositories/laboratory_repository.dart';
import '../datasources/laboratory_local_datasource.dart';

class LaboratoryRepositoryImpl implements LaboratoryRepository {
  LaboratoryRepositoryImpl({LaboratoryLocalDataSource? dataSource})
      : _dataSource = dataSource ?? LaboratoryLocalDataSource.instance;

  final LaboratoryLocalDataSource _dataSource;

  @override
  List<LabResultEntry> getResultsForPatient(String patientId) {
    return _dataSource.getResultsForPatient(patientId);
  }

  @override
  LabResultEntry addResult({
    required String patientId,
    String? doctorId,
    required String testName,
    required String labName,
    required String summary,
    required List<LabResultRow> rows,
    required String recommendation,
    String doctorNotes = '',
  }) {
    return _dataSource.addResult(
      patientId: patientId,
      doctorId: doctorId,
      testName: testName,
      labName: labName,
      summary: summary,
      rows: rows,
      recommendation: recommendation,
      doctorNotes: doctorNotes,
    );
  }
}
