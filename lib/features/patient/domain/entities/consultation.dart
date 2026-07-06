enum ConsultationStatus { pending, answered }

/// A question a patient sends to a doctor about a specific lab result,
/// prescription, or medical record.
class Consultation {
  const Consultation({
    required this.id,
    required this.patientId,
    required this.doctorName,
    required this.subject,
    required this.patientQuestion,
    required this.status,
    required this.dateLabel,
    this.doctorAnswer,
  });

  final String id;
  final String patientId;
  final String doctorName;

  /// What the consultation is about, e.g. a test name.
  final String subject;
  final String patientQuestion;
  final ConsultationStatus status;
  final String dateLabel;
  final String? doctorAnswer;

  Consultation copyWith({
    ConsultationStatus? status,
    String? doctorAnswer,
  }) {
    return Consultation(
      id: id,
      patientId: patientId,
      doctorName: doctorName,
      subject: subject,
      patientQuestion: patientQuestion,
      status: status ?? this.status,
      dateLabel: dateLabel,
      doctorAnswer: doctorAnswer ?? this.doctorAnswer,
    );
  }
}
