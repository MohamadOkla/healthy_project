import '../entities/medical_record_entry.dart';

/// Domain-level contract for reading and adding medical records.
///
/// The concrete implementation currently backs onto an in-memory local data
/// source (see [MedicalRecordsRepositoryImpl]); a future implementation could
/// swap this for a real API-backed data source without any change required
/// in the code that depends on this interface.
abstract interface class MedicalRecordsRepository {
  List<MedicalRecordEntry> getRecordsForPatient(String patientId);

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
  });
}
