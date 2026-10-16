import '../../../laboratory/domain/entities/lab_result_entry.dart';
import '../../../medical_records/domain/entities/medical_attachment_entry.dart';
import '../../../medical_records/domain/entities/medical_record_entry.dart';
import '../../../prescriptions/domain/entities/prescription_entry.dart';

enum MedicalTimelineEventType { visit, prescription, labResult }

class MedicalTimelineEvent {
  const MedicalTimelineEvent({
    required this.id,
    required this.type,
    required this.sourceId,
    required this.patientId,
    required this.title,
    required this.summary,
    required this.originalEntry,
    this.occurredAt,
    this.doctorId,
    this.doctorName,
    this.hospital,
    this.details,
    this.attachments = const [],
  });

  /// Unique timeline key, namespaced by source type.
  final String id;
  final MedicalTimelineEventType type;
  final String sourceId;
  final String patientId;
  final DateTime? occurredAt;
  final String title;
  final String summary;
  final String? doctorId;
  final String? doctorName;
  final String? hospital;
  final String? details;
  final List<MedicalAttachmentEntry> attachments;
  final Object originalEntry;

  static MedicalTimelineEvent fromVisit(MedicalRecordEntry record,
          {List<MedicalAttachmentEntry> attachments = const []}) =>
      MedicalTimelineEvent(
        id: 'visit:${record.id}',
        type: MedicalTimelineEventType.visit,
        sourceId: record.id,
        patientId: record.patientId,
        occurredAt: record.occurredAt,
        title: record.diagnosis,
        summary: record.symptoms.isEmpty ? record.doctorNotes : record.symptoms,
        details: record.doctorNotes.isEmpty ? null : record.doctorNotes,
        doctorId: record.doctorId,
        doctorName: record.doctorName,
        hospital: record.hospital,
        attachments: attachments,
        originalEntry: record,
      );

  static MedicalTimelineEvent fromPrescription(
          PrescriptionEntry prescription) =>
      MedicalTimelineEvent(
        id: 'prescription:${prescription.id}',
        type: MedicalTimelineEventType.prescription,
        sourceId: prescription.id,
        patientId: prescription.patientId,
        occurredAt: prescription.issuedAt,
        title: prescription.medicines.isEmpty
            ? 'وصفة طبية'
            : prescription.medicines.first.name,
        summary: prescription.medicines.isEmpty
            ? prescription.notes
            : '${prescription.medicines.first.dose} · ${prescription.medicines.first.frequency}',
        details: prescription.notes.isEmpty ? null : prescription.notes,
        doctorId: prescription.doctorId,
        doctorName: prescription.doctorName,
        originalEntry: prescription,
      );

  static MedicalTimelineEvent fromLabResult(LabResultEntry result,
          {List<MedicalAttachmentEntry> attachments = const []}) =>
      MedicalTimelineEvent(
        id: 'lab:${result.id}',
        type: MedicalTimelineEventType.labResult,
        sourceId: result.id,
        patientId: result.patientId,
        occurredAt: result.performedAt,
        title: result.testName,
        summary: result.summary,
        details: result.recommendation.isEmpty ? null : result.recommendation,
        doctorId: result.doctorId,
        hospital: result.labName,
        attachments: attachments,
        originalEntry: result,
      );
}
