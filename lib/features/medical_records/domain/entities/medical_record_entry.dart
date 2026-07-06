/// A single medical record entry created by a doctor for a patient during
/// or after a visit.
class MedicalRecordEntry {
  const MedicalRecordEntry({
    required this.id,
    required this.patientId,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.visitDate,
    required this.diagnosis,
    required this.symptoms,
    required this.doctorNotes,
    this.vitals = const [],
    this.medications = const [],
    this.testsRequired = const [],
  });

  final String id;
  final String patientId;
  final String doctorName;
  final String specialty;
  final String hospital;
  final String visitDate;
  final String diagnosis;
  final String symptoms;
  final String doctorNotes;

  /// Pairs of (label, value), e.g. ("ضغط الدم", "120/80").
  final List<(String, String)> vitals;

  /// Free-text medication lines, e.g. "Atorvastatin 20mg مساءً".
  final List<String> medications;

  /// Tests the doctor asked for as part of this visit's plan.
  final List<String> testsRequired;
}
