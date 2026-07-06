import '../../domain/entities/consultation.dart';

class ConsultationsLocalDataSource {
  ConsultationsLocalDataSource._();

  static final ConsultationsLocalDataSource instance =
      ConsultationsLocalDataSource._();

  int _nextId = 100;

  final Map<String, List<Consultation>> _consultationsByPatient = {
    'p1': [
      const Consultation(
        id: 'c1',
        patientId: 'p1',
        doctorName: 'د. سارة منصور',
        subject: 'نتيجة تحليل HbA1c',
        patientQuestion: 'هل ارتفاع القيمة يستدعي تعديل الجرعة الحالية؟',
        status: ConsultationStatus.answered,
        dateLabel: 'منذ 3 أيام',
        doctorAnswer:
            'لا داعي لتعديل الجرعة الآن، راجعني بعد إعادة الفحص خلال 6 أسابيع.',
      ),
    ],
  };

  List<Consultation> getConsultationsForPatient(String patientId) {
    final list = _consultationsByPatient[patientId];
    if (list == null) return const [];
    return List.unmodifiable(list.reversed);
  }

  List<Consultation> getPendingConsultations() {
    return _consultationsByPatient.values
        .expand((list) => list)
        .where((c) => c.status == ConsultationStatus.pending)
        .toList(growable: false);
  }

  Consultation addConsultation({
    required String patientId,
    required String doctorName,
    required String subject,
    required String patientQuestion,
  }) {
    final consultation = Consultation(
      id: 'c${_nextId++}',
      patientId: patientId,
      doctorName: doctorName,
      subject: subject,
      patientQuestion: patientQuestion,
      status: ConsultationStatus.pending,
      dateLabel: 'الآن',
    );
    final list = _consultationsByPatient.putIfAbsent(patientId, () => []);
    list.add(consultation);
    return consultation;
  }
}
