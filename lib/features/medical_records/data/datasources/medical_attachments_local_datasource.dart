import '../../domain/entities/medical_attachment_entry.dart';

/// Local attachment metadata; binary documents are intentionally not loaded
/// into the timeline list.
class MedicalAttachmentsLocalDataSource {
  MedicalAttachmentsLocalDataSource._();

  static final MedicalAttachmentsLocalDataSource instance =
      MedicalAttachmentsLocalDataSource._();

  static final List<MedicalAttachmentEntry> _attachments = [
    MedicalAttachmentEntry(
      id: 'att-lab0-report',
      patientId: 'p1',
      fileName: 'تقرير التحاليل المخبري.pdf',
      sourceType: 'labResult',
      sourceId: 'lab0',
      addedAt: DateTime(2026, 7, 4),
    ),
  ];

  List<MedicalAttachmentEntry> getForPatient(String patientId) =>
      List.unmodifiable(
          _attachments.where((item) => item.patientId == patientId));
}
