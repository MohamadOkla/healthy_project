import '../../domain/entities/lab_result_entry.dart';

class LaboratoryLocalDataSource {
  LaboratoryLocalDataSource._();

  static final LaboratoryLocalDataSource instance =
      LaboratoryLocalDataSource._();

  int _nextId = 100;

  final Map<String, List<LabResultEntry>> _resultsByPatient = {
    'p1': [
      const LabResultEntry(
        id: 'lab0',
        patientId: 'p1',
        testName: 'CBC + Vitamin D + HbA1c',
        testDate: '4 يوليو 2026',
        labName: 'مخبر مشفى دمشق الجامعي',
        isCompleted: true,
        summary: 'معظم القيم ضمن الطبيعي مع انخفاض بسيط في Vitamin D.',
        rows: [
          LabResultRow(
            name: 'Hemoglobin',
            value: '14.2 g/dL',
            normalRange: '13.5 - 17.5',
            isNormal: true,
          ),
          LabResultRow(
            name: 'WBC',
            value: '6.1 x10^9/L',
            normalRange: '4.0 - 11.0',
            isNormal: true,
          ),
          LabResultRow(
            name: 'Vitamin D',
            value: '18 ng/mL',
            normalRange: '30 - 100',
            isNormal: false,
          ),
          LabResultRow(
            name: 'HbA1c',
            value: '5.4%',
            normalRange: 'أقل من 5.7%',
            isNormal: true,
          ),
        ],
        recommendation:
            'الالتزام بالمكملات، التعرض الآمن للشمس، ومراجعة الطبيب عند استمرار التعب.',
        doctorNotes: 'ينصح بإعادة فحص Vitamin D بعد 8 أسابيع من بدء العلاج.',
      ),
    ],
    'p2': [
      const LabResultEntry(
        id: 'lab1',
        patientId: 'p2',
        testName: 'HbA1c + Fasting Glucose',
        testDate: '2 يوليو 2026',
        labName: 'مخبر مشفى دمشق الجامعي',
        isCompleted: true,
        summary: 'تحسّن طفيف عن الفحص السابق مع بقاء السكر التراكمي مرتفعًا قليلًا.',
        rows: [
          LabResultRow(
            name: 'HbA1c',
            value: '7.1%',
            normalRange: '4.0% - 5.6%',
            isNormal: false,
          ),
          LabResultRow(
            name: 'Fasting Glucose',
            value: '132 mg/dL',
            normalRange: '70 - 100 mg/dL',
            isNormal: false,
          ),
        ],
        recommendation: 'مراجعة الجرعة الحالية بعد 6 أسابيع من الالتزام بالحمية.',
        doctorNotes: 'ينصح بإعادة الفحص بعد إجراء التعديل الغذائي المتفق عليه.',
      ),
    ],
  };

  List<LabResultEntry> getResultsForPatient(String patientId) {
    return List.unmodifiable(_resultsByPatient[patientId] ?? const []);
  }

  LabResultEntry addResult({
    required String patientId,
    required String testName,
    required String labName,
    required String summary,
    required List<LabResultRow> rows,
    required String recommendation,
    String doctorNotes = '',
  }) {
    final entry = LabResultEntry(
      id: 'lab${_nextId++}',
      patientId: patientId,
      testName: testName,
      testDate: 'اليوم',
      labName: labName,
      isCompleted: true,
      summary: summary,
      rows: rows,
      recommendation: recommendation,
      doctorNotes: doctorNotes,
    );
    final list = _resultsByPatient.putIfAbsent(patientId, () => []);
    list.insert(0, entry);
    return entry;
  }
}
