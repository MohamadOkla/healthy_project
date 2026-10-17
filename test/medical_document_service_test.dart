import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:healty_app/core/services/medical_document_service.dart';
import 'package:healty_app/features/laboratory/domain/entities/lab_result_entry.dart';
import 'package:healty_app/features/medical_records/domain/entities/medical_record_entry.dart';
import 'package:healty_app/features/prescriptions/domain/entities/prescription_entry.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory outputDirectory;
  late MedicalDocumentService service;

  setUp(() async {
    outputDirectory =
        await Directory.systemTemp.createTemp('healthy-pdf-test-');
    service = MedicalDocumentService(temporaryDirectory: outputDirectory);
  });

  tearDown(() async {
    if (await outputDirectory.exists()) {
      await outputDirectory.delete(recursive: true);
    }
  });

  test('creates a local Arabic medical record PDF from the selected record',
      () async {
    final file = await service.createMedicalRecordPdf(
      const MedicalRecordEntry(
        id: 'record/42',
        patientId: 'patient-1',
        doctorName: 'د. سارة',
        specialty: 'قلبية',
        hospital: 'مشفى الجامعة',
        visitDate: '17 أكتوبر 2026',
        diagnosis: 'تشخيص للاختبار',
        symptoms: 'صداع',
        doctorNotes: 'متابعة بعد أسبوع',
        vitals: [('الضغط', '120/80')],
      ),
    );

    expect(file.path, endsWith('medical_record_record_42.pdf'));
    expect(await file.exists(), isTrue);
    expect(await _hasPdfSignature(file), isTrue);
    expect(await file.length(), greaterThan(1000));
  });

  test('creates prescription and lab result PDFs with safe item names',
      () async {
    final prescription = await service.createPrescriptionPdf(
      const PrescriptionEntry(
        id: 'rx:7',
        patientId: 'patient-1',
        doctorName: 'د. سارة',
        issueDate: '17 أكتوبر 2026',
        expiryDate: '17 نوفمبر 2026',
        isActive: true,
        medicines: [
          PrescriptionMedicine(
            name: 'دواء',
            dose: 'قرص',
            frequency: 'يومياً',
            duration: 'أسبوع',
            instructions: 'بعد الطعام',
          ),
        ],
        notes: 'ملاحظات',
      ),
    );
    final result = await service.createLabResultPdf(
      const LabResultEntry(
        id: 'lab 9',
        patientId: 'patient-1',
        testName: 'فحص الدم',
        testDate: '17 أكتوبر 2026',
        labName: 'مخبر الجامعة',
        isCompleted: true,
        summary: 'النتيجة طبيعية',
        rows: [
          LabResultRow(
            name: 'الهيموغلوبين',
            value: '14',
            normalRange: '12-16',
            isNormal: true,
          ),
        ],
        recommendation: 'لا يوجد',
      ),
    );

    expect(prescription.path, endsWith('prescription_rx_7.pdf'));
    expect(result.path, endsWith('lab_result_lab_9.pdf'));
    expect(await _hasPdfSignature(prescription), isTrue);
    expect(await _hasPdfSignature(result), isTrue);
  });

  test('sanitizes identifiers before using them as file names', () {
    expect(
      MedicalDocumentService.safeFileName('medical_record', '../رقم 1'),
      'medical_record________1.pdf',
    );
  });
}

Future<bool> _hasPdfSignature(File file) async {
  final bytes = await file.openRead(0, 5).fold<List<int>>(
    [],
    (output, chunk) => output..addAll(chunk),
  );
  return String.fromCharCodes(bytes) == '%PDF-';
}
