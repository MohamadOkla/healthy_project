import '../entities/lab_result_entry.dart';

abstract interface class LaboratoryRepository {
  List<LabResultEntry> getResultsForPatient(String patientId);

  LabResultEntry addResult({
    required String patientId,
    required String testName,
    required String labName,
    required String summary,
    required List<LabResultRow> rows,
    required String recommendation,
    String doctorNotes = '',
  });
}
