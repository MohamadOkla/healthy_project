import '../entities/consultation.dart';

abstract interface class ConsultationsRepository {
  List<Consultation> getConsultationsForPatient(String patientId);

  /// All consultations still awaiting a doctor's answer, across every
  /// patient - used to badge the doctor's notifications.
  List<Consultation> getPendingConsultations();

  Consultation addConsultation({
    required String patientId,
    required String doctorName,
    required String subject,
    required String patientQuestion,
  });
}
