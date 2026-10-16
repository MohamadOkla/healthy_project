/// Lightweight local metadata for an attachment. File contents are loaded
/// only by the owning detail screen, never by the timeline.
class MedicalAttachmentEntry {
  const MedicalAttachmentEntry({
    required this.id,
    required this.patientId,
    required this.fileName,
    required this.sourceType,
    required this.sourceId,
    required this.addedAt,
  });

  final String id;
  final String patientId;
  final String fileName;
  final String sourceType;
  final String sourceId;
  final DateTime addedAt;
}
