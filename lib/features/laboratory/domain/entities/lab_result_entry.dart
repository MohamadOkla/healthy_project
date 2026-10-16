/// A single row within a lab result table, e.g. one measured value.
class LabResultRow {
  const LabResultRow({
    required this.name,
    required this.value,
    required this.normalRange,
    required this.isNormal,
  });

  final String name;
  final String value;
  final String normalRange;
  final bool isNormal;
}

/// A lab test result a doctor orders and later records for a patient.
class LabResultEntry {
  const LabResultEntry({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.testName,
    required this.testDate,
    this.performedAt,
    required this.labName,
    required this.isCompleted,
    required this.summary,
    required this.rows,
    required this.recommendation,
    this.doctorNotes = '',
  });

  final String id;
  final String patientId;
  final String? doctorId;
  final String testName;
  final String testDate;
  final DateTime? performedAt;
  final String labName;
  final bool isCompleted;
  final String summary;
  final List<LabResultRow> rows;
  final String recommendation;
  final String doctorNotes;
}
