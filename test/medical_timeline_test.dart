import 'package:flutter_test/flutter_test.dart';
import 'package:healty_app/features/laboratory/domain/entities/lab_result_entry.dart';
import 'package:healty_app/features/laboratory/domain/repositories/laboratory_repository.dart';
import 'package:healty_app/features/medical_records/domain/entities/medical_record_entry.dart';
import 'package:healty_app/features/medical_records/domain/repositories/medical_records_repository.dart';
import 'package:healty_app/features/patient/data/repositories/medical_timeline_repository.dart';
import 'package:healty_app/features/patient/presentation/cubit/medical_timeline_cubit.dart';
import 'package:healty_app/features/patient/presentation/cubit/medical_timeline_state.dart';
import 'package:healty_app/features/patient/presentation/models/medical_timeline_event.dart';
import 'package:healty_app/features/prescriptions/domain/entities/prescription_entry.dart';
import 'package:healty_app/features/prescriptions/domain/repositories/prescriptions_repository.dart';

void main() {
  test(
      'merges event types newest first, deduplicates and associates attachments',
      () {
    final record = _visit('visit-1', DateTime(2026, 3, 10));
    final prescription = _prescription('rx-1', DateTime(2026, 3, 12));
    final lab = _lab('lab0', DateTime(2026, 3, 11));
    final repository = MedicalTimelineRepository(
      records: _Records([record, record]),
      prescriptions: _Prescriptions([prescription]),
      laboratory: _Laboratory([lab]),
    );

    final events = repository.getEventsForPatient('p1');
    expect(events.map((event) => event.type), [
      MedicalTimelineEventType.prescription,
      MedicalTimelineEventType.labResult,
      MedicalTimelineEventType.visit,
    ]);
    expect(events.map((event) => event.id).toSet(), hasLength(3));
    expect(events[1].attachments.map((attachment) => attachment.id),
        ['att-lab0-report']);
  });

  test('combines type, inclusive date range and doctor ID filters', () async {
    final repository = MedicalTimelineRepository(
      records: _Records([
        _visit('visit-a', DateTime(2026, 3, 10, 23, 59), doctorId: 'doc1'),
        _visit('visit-b', DateTime(2026, 3, 10), doctorId: 'doc2'),
      ]),
      prescriptions: _Prescriptions([
        _prescription('rx-a', DateTime(2026, 3, 10), doctorId: 'doc1'),
      ]),
      laboratory: _Laboratory([
        _lab('lab-a', DateTime(2026, 3, 11), doctorId: 'doc1'),
      ]),
    );
    final cubit = MedicalTimelineCubit(patientId: 'p1', repository: repository);
    final doctor =
        cubit.availableDoctors.singleWhere((item) => item.id == 'doc1');
    expect(cubit.setStartDate(DateTime(2026, 3, 10, 18)), isTrue);
    expect(cubit.setEndDate(DateTime(2026, 3, 10, 2)), isTrue);
    cubit.setDoctorFilter(doctor);
    cubit.setTypeFilter(TimelineTypeFilter.visits);

    expect(cubit.visibleEvents.map((event) => event.sourceId), ['visit-a']);
    expect(cubit.setStartDate(DateTime(2026, 3, 11)), isFalse);
    expect(cubit.state.startDate, DateTime(2026, 3, 10));
    expect(cubit.state.endDate, DateTime(2026, 3, 10));
    await cubit.close();
  });

  test('keeps incomplete events without a doctor and isolates patient data',
      () {
    final repository = MedicalTimelineRepository(
      records: _Records([
        _visit('p1-unknown', null,
            patientId: 'p1', doctorId: '', doctorName: ''),
        _visit('p2-private', DateTime(2026, 3, 10), patientId: 'p2'),
      ]),
      prescriptions: _Prescriptions([
        _prescription('p2-rx', DateTime(2026, 3, 10), patientId: 'p2'),
      ]),
      laboratory: _Laboratory([
        _lab('p2-lab', DateTime(2026, 3, 10), patientId: 'p2'),
      ]),
    );
    final events = repository.getEventsForPatient('p1');
    expect(events.map((event) => event.sourceId), ['p1-unknown']);
    expect(events.single.doctorName, '');

    final cubit = MedicalTimelineCubit(patientId: 'p1', repository: repository);
    expect(cubit.visibleEvents, hasLength(1));
    expect(cubit.setStartDate(DateTime(2026, 3, 1)), isTrue);
    expect(cubit.visibleEvents, isEmpty); // Undated rows cannot match a range.
    cubit.clearStartDate();
    cubit.setDoctorFilter(const TimelineDoctorFilter(
        key: 'id:doc1', id: 'doc1', name: 'د. سارة منصور'));
    expect(
        cubit.visibleEvents, isEmpty); // Missing doctor IDs are not inferred.
    cubit.close();
  });
}

MedicalRecordEntry _visit(String id, DateTime? date,
        {String patientId = 'p1',
        String doctorId = 'doc1',
        String doctorName = 'د. سارة منصور'}) =>
    MedicalRecordEntry(
      id: id,
      patientId: patientId,
      doctorId: doctorId.isEmpty ? null : doctorId,
      doctorName: doctorName,
      specialty: 'قلبية',
      hospital: 'مشفى دمشق الجامعي',
      visitDate: date?.toIso8601String() ?? '',
      occurredAt: date,
      diagnosis: 'زيارة متابعة',
      symptoms: '',
      doctorNotes: '',
    );

PrescriptionEntry _prescription(String id, DateTime date,
        {String patientId = 'p1', String doctorId = 'doc1'}) =>
    PrescriptionEntry(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      doctorName: 'د. سارة منصور',
      issueDate: date.toIso8601String(),
      issuedAt: date,
      expiryDate: '',
      isActive: true,
      medicines: const [],
      notes: '',
    );

LabResultEntry _lab(String id, DateTime date,
        {String patientId = 'p1', String doctorId = 'doc1'}) =>
    LabResultEntry(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      testName: 'تحليل دم',
      testDate: date.toIso8601String(),
      performedAt: date,
      labName: 'مخبر مشفى دمشق الجامعي',
      isCompleted: true,
      summary: 'نتيجة تجريبية',
      rows: const [],
      recommendation: '',
    );

class _Records implements MedicalRecordsRepository {
  _Records(this.records);
  final List<MedicalRecordEntry> records;
  @override
  List<MedicalRecordEntry> getRecordsForPatient(String patientId) => records;
  @override
  MedicalRecordEntry addRecord(
          {required String patientId,
          String? doctorId,
          required String doctorName,
          required String specialty,
          required String hospital,
          required String diagnosis,
          required String symptoms,
          required String doctorNotes,
          List<(String, String)> vitals = const [],
          List<String> medications = const [],
          List<String> testsRequired = const []}) =>
      throw UnimplementedError();
}

class _Prescriptions implements PrescriptionsRepository {
  _Prescriptions(this.prescriptions);
  final List<PrescriptionEntry> prescriptions;
  @override
  List<PrescriptionEntry> getPrescriptionsForPatient(String patientId) =>
      prescriptions;
  @override
  PrescriptionEntry addPrescription(
          {required String patientId,
          String? doctorId,
          required String doctorName,
          required String expiryDate,
          required List<PrescriptionMedicine> medicines,
          required String notes,
          String warnings = ''}) =>
      throw UnimplementedError();
}

class _Laboratory implements LaboratoryRepository {
  _Laboratory(this.results);
  final List<LabResultEntry> results;
  @override
  List<LabResultEntry> getResultsForPatient(String patientId) => results;
  @override
  LabResultEntry addResult(
          {required String patientId,
          String? doctorId,
          required String testName,
          required String labName,
          required String summary,
          required List<LabResultRow> rows,
          required String recommendation,
          String doctorNotes = ''}) =>
      throw UnimplementedError();
}
