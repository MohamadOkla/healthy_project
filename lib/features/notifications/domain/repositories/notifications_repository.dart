import '../entities/app_notification.dart';

abstract interface class NotificationsRepository {
  List<AppNotification> getNotificationsForPatient(String patientId);

  int getUnreadCountForPatient(String patientId);

  void markAsRead(String notificationId);

  AppNotification addNotification({
    required String patientId,
    required AppNotificationType type,
    required String title,
    required String description,
    String? actionRoute,
    Object? actionExtra,
  });
}
