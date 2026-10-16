import '../../../laboratory/data/repositories/laboratory_repository_impl.dart';
import '../../../laboratory/domain/entities/lab_result_entry.dart';
import '../../../laboratory/domain/repositories/laboratory_repository.dart';
import '../../../medical_records/data/datasources/medical_attachments_local_datasource.dart';
import '../../../medical_records/data/repositories/medical_records_repository_impl.dart';
import '../../../medical_records/domain/entities/medical_attachment_entry.dart';
import '../../../medical_records/domain/entities/medical_record_entry.dart';
import '../../../medical_records/domain/repositories/medical_records_repository.dart';
import '../../../prescriptions/data/repositories/prescriptions_repository_impl.dart';
import '../../../prescriptions/domain/entities/prescription_entry.dart';
import '../../../prescriptions/domain/repositories/prescriptions_repository.dart';
import '../../presentation/models/medical_timeline_event.dart';

class MedicalTimelineRepository {
  MedicalTimelineRepository({
    MedicalRecordsRepository? records,
    PrescriptionsRepository? prescriptions,
    LaboratoryRepository? laboratory,
    MedicalAttachmentsLocalDataSource? attachments,
  })  : _records = records ?? MedicalRecordsRepositoryImpl(),
        _prescriptions = prescriptions ?? PrescriptionsRepositoryImpl(),
        _laboratory = laboratory ?? LaboratoryRepositoryImpl(),
        _attachments =
            attachments ?? MedicalAttachmentsLocalDataSource.instance;

  final MedicalRecordsRepository _records;
  final PrescriptionsRepository _prescriptions;
  final LaboratoryRepository _laboratory;
  final MedicalAttachmentsLocalDataSource _attachments;

  List<MedicalTimelineEvent> getEventsForPatient(String patientId) {
    final attachments = _attachments.getForPatient(patientId);
    final bySource = <String, List<MedicalAttachmentEntry>>{};
    for (final attachment in attachments) {
      bySource
          .putIfAbsent(
              '${attachment.sourceType}:${attachment.sourceId}', () => [])
          .add(attachment);
    }

    final events = <MedicalTimelineEvent>[];
    for (final MedicalRecordEntry record
        in _records.getRecordsForPatient(patientId)) {
      if (record.patientId != patientId) continue;
      events.add(MedicalTimelineEvent.fromVisit(record,
          attachments: bySource['medicalRecord:${record.id}'] ?? const []));
    }
    for (final PrescriptionEntry prescription
        in _prescriptions.getPrescriptionsForPatient(patientId)) {
      if (prescription.patientId != patientId) continue;
      events.add(MedicalTimelineEvent.fromPrescription(prescription));
    }
    for (final LabResultEntry result
        in _laboratory.getResultsForPatient(patientId)) {
      if (result.patientId != patientId) continue;
      events.add(MedicalTimelineEvent.fromLabResult(result,
          attachments: bySource['labResult:${result.id}'] ?? const []));
    }

    final unique = <String, MedicalTimelineEvent>{};
    for (final event in events) {
      unique.putIfAbsent(event.id, () => event);
    }
    final sorted = unique.values.toList();
    sorted.sort((a, b) {
      final left = a.occurredAt;
      final right = b.occurredAt;
      if (left == null) return right == null ? 0 : 1;
      if (right == null) return -1;
      return right.compareTo(left);
    });
    return List.unmodifiable(sorted);
  }
}
