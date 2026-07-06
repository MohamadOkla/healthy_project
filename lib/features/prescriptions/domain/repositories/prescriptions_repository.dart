import '../entities/prescription_entry.dart';

abstract interface class PrescriptionsRepository {
  List<PrescriptionEntry> getPrescriptionsForPatient(String patientId);

  PrescriptionEntry addPrescription({
    required String patientId,
    required String doctorName,
    required String expiryDate,
    required List<PrescriptionMedicine> medicines,
    required String notes,
    String warnings = '',
  });
}
