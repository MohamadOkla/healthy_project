import '../../domain/entities/prescription_entry.dart';

class PrescriptionsLocalDataSource {
  PrescriptionsLocalDataSource._();

  static final PrescriptionsLocalDataSource instance =
      PrescriptionsLocalDataSource._();

  int _nextId = 100;

  final Map<String, List<PrescriptionEntry>> _prescriptionsByPatient = {
    'p1': [
      PrescriptionEntry(
        id: 'rx1',
        patientId: 'p1',
        doctorId: 'doc1',
        doctorName: 'د. سارة منصور',
        issueDate: '5 يوليو 2026',
        issuedAt: DateTime(2026, 7, 5),
        expiryDate: '5 أغسطس 2026',
        isActive: true,
        medicines: [
          PrescriptionMedicine(
            name: 'Amlodipine 5mg',
            dose: 'قرص واحد',
            frequency: 'مرة يوميًا',
            duration: '30 يومًا',
            instructions: 'يُؤخذ صباحًا مع الطعام',
          ),
        ],
        notes: 'مراجعة الضغط بعد أسبوعين من بدء العلاج.',
        warnings:
            'تجنب إيقاف الدواء دون استشارة الطبيب. أخبر الطبيب في حال وجود حساسية دوائية.',
      ),
    ],
    'p3': [
      PrescriptionEntry(
        id: 'rx2',
        patientId: 'p3',
        doctorId: 'doc1',
        doctorName: 'د. سارة منصور',
        issueDate: '1 يوليو 2026',
        issuedAt: DateTime(2026, 7, 1),
        expiryDate: '15 يوليو 2026',
        isActive: true,
        medicines: [
          PrescriptionMedicine(
            name: 'Ibuprofen 400mg',
            dose: 'قرص واحد',
            frequency: 'عند اللزوم كل 8 ساعات',
            duration: '10 أيام',
            instructions: 'بعد الطعام مباشرة',
          ),
        ],
        notes: 'إيقاف الدواء عند زوال الألم.',
      ),
    ],
  };

  List<PrescriptionEntry> getPrescriptionsForPatient(String patientId) {
    return List.unmodifiable(_prescriptionsByPatient[patientId] ?? const []);
  }

  PrescriptionEntry addPrescription({
    required String patientId,
    String? doctorId,
    required String doctorName,
    required String expiryDate,
    required List<PrescriptionMedicine> medicines,
    required String notes,
    String warnings = '',
  }) {
    final list = _prescriptionsByPatient.putIfAbsent(patientId, () => []);
    final entry = PrescriptionEntry(
      id: 'rx${_nextId++}',
      patientId: patientId,
      doctorId: doctorId,
      doctorName: doctorName,
      issueDate: 'اليوم',
      issuedAt: DateTime.now(),
      expiryDate: expiryDate,
      isActive: true,
      medicines: medicines,
      notes: notes,
      warnings: warnings,
    );
    list.insert(0, entry);
    return entry;
  }
}
