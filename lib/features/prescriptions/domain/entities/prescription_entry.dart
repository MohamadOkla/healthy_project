/// A single medicine line item within a prescription.
class PrescriptionMedicine {
  const PrescriptionMedicine({
    required this.name,
    required this.dose,
    required this.frequency,
    required this.duration,
    required this.instructions,
  });

  final String name;
  final String dose;
  final String frequency;
  final String duration;
  final String instructions;
}

/// A prescription a doctor issues for a patient.
class PrescriptionEntry {
  const PrescriptionEntry({
    required this.id,
    required this.patientId,
    required this.doctorName,
    required this.issueDate,
    required this.expiryDate,
    required this.isActive,
    required this.medicines,
    required this.notes,
    this.warnings = '',
  });

  final String id;
  final String patientId;
  final String doctorName;
  final String issueDate;
  final String expiryDate;
  final bool isActive;
  final List<PrescriptionMedicine> medicines;
  final String notes;
  final String warnings;
}
