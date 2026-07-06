enum AppNotificationType { appointment, prescription, labResult, medicalRecord, general }

/// A single notification for a patient.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.patientId,
    required this.type,
    required this.title,
    required this.description,
    required this.timeLabel,
    required this.isRead,
    this.actionRoute,
    this.actionExtra,
  });

  final String id;
  final String patientId;
  final AppNotificationType type;
  final String title;
  final String description;

  /// Pre-formatted relative time, e.g. "منذ 10 دقائق" - kept as a plain
  /// string for consistency with how the rest of the app represents dates
  /// and times (no real DateTime-based formatting is used anywhere else).
  final String timeLabel;

  final bool isRead;

  /// Where "view" should navigate to, if anywhere.
  final String? actionRoute;

  /// Optional data to pass through navigation (e.g. the specific record).
  final Object? actionExtra;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      patientId: patientId,
      type: type,
      title: title,
      description: description,
      timeLabel: timeLabel,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute,
      actionExtra: actionExtra,
    );
  }
}
