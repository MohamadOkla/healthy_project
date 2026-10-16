import '../../domain/entities/medical_record_entry.dart';

/// In-memory data source for medical records.
///
/// This mirrors the pattern used by [LocalStorageService] elsewhere in the
/// app: a single instance lives for the app session, so records added while
/// the app is running (e.g. by a doctor) are visible everywhere that reads
/// through this data source until the app is closed.
class MedicalRecordsLocalDataSource {
  MedicalRecordsLocalDataSource._();

  static final MedicalRecordsLocalDataSource instance =
      MedicalRecordsLocalDataSource._();

  int _nextId = 100;

  final Map<String, List<MedicalRecordEntry>> _recordsByPatient = {
    'p1': [
      MedicalRecordEntry(
        id: 'mr1',
        patientId: 'p1',
        doctorId: 'doc1',
        doctorName: 'د. سارة منصور',
        specialty: 'قلبية',
        hospital: 'مشفى دمشق الجامعي',
        visitDate: '5 يوليو 2026',
        occurredAt: DateTime(2026, 7, 5),
        diagnosis: 'اضطراب بسيط في ضغط الدم مع حالة مستقرة',
        symptoms: 'إرهاق خفيف، صداع متقطع',
        doctorNotes: 'ينصح بالمتابعة بعد أسبوعين ومراقبة الضغط يوميًا.',
        vitals: [
          ('ضغط الدم', '130/85'),
          ('النبض', '78 نبضة/د'),
          ('الحرارة', '36.8°'),
          ('الوزن', '79 كغ'),
        ],
        medications: ['Amlodipine 5mg مرة يوميًا صباحًا'],
        testsRequired: ['CBC', 'Lipid Profile'],
      ),
    ],
    'p2': [
      MedicalRecordEntry(
        id: 'mr2',
        patientId: 'p2',
        doctorId: 'doc1',
        doctorName: 'د. سارة منصور',
        specialty: 'باطنية',
        hospital: 'مشفى دمشق الجامعي',
        visitDate: '3 يوليو 2026',
        occurredAt: DateTime(2026, 7, 3),
        diagnosis: 'متابعة خطة علاج السكري',
        symptoms: 'عطش زائد بشكل خفيف',
        doctorNotes: 'الالتزام بالحمية جيد، تعديل بسيط بجرعة الأنسولين.',
        vitals: [
          ('ضغط الدم', '122/80'),
          ('سكر الدم', '138 mg/dL'),
          ('الوزن', '91 كغ'),
        ],
      ),
    ],
  };

  List<MedicalRecordEntry> getRecordsForPatient(String patientId) {
    return List.unmodifiable(_recordsByPatient[patientId] ?? const []);
  }

  MedicalRecordEntry addRecord({
    required String patientId,
    String? doctorId,
    required String doctorName,
    required String specialty,
    required String hospital,
    required String diagnosis,
    required String symptoms,
    required String doctorNotes,
    List<(String, String)> vitals = const [],
    List<String> medications = const [],
    List<String> testsRequired = const [],
  }) {
    final list = _recordsByPatient.putIfAbsent(patientId, () => []);
    final entry = MedicalRecordEntry(
      id: 'mr${_nextId++}',
      patientId: patientId,
      doctorId: doctorId,
      doctorName: doctorName,
      specialty: specialty,
      hospital: hospital,
      visitDate: 'اليوم',
      occurredAt: DateTime.now(),
      diagnosis: diagnosis,
      symptoms: symptoms,
      doctorNotes: doctorNotes,
      vitals: vitals,
      medications: medications,
      testsRequired: testsRequired,
    );
    list.insert(0, entry);
    return entry;
  }
}
