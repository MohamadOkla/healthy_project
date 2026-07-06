import '../../domain/entities/prescription_entry.dart';

class PrescriptionsLocalDataSource {
  PrescriptionsLocalDataSource._();

  static final PrescriptionsLocalDataSource instance =
      PrescriptionsLocalDataSource._();

  int _nextId = 100;

  final Map<String, List<PrescriptionEntry>> _prescriptionsByPatient = {
    'p1': [
      const PrescriptionEntry(
        id: 'rx1',
        patientId: 'p1',
        doctorName: 'د. سارة منصور',
        issueDate: '5 يوليو 2026',
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
      const PrescriptionEntry(
        id: 'rx2',
        patientId: 'p3',
        doctorName: 'د. سارة منصور',
        issueDate: '1 يوليو 2026',
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
    required String doctorName,
    required String expiryDate,
    required List<PrescriptionMedicine> medicines,
    required String notes,
    String warnings = '',
  }) {
    final entry = PrescriptionEntry(
      id: 'rx${_nextId++}',
      patientId: patientId,
      doctorName: doctorName,
      issueDate: 'اليوم',
      expiryDate: expiryDate,
      isActive: true,
      medicines: medicines,
      notes: notes,
      warnings: warnings,
    );
    final list = _prescriptionsByPatient.putIfAbsent(patientId, () => []);
    list.insert(0, entry);
    return entry;
  }
}
