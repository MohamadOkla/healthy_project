import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_local_datasource.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl({NotificationsLocalDataSource? dataSource})
      : _dataSource = dataSource ?? NotificationsLocalDataSource.instance;

  final NotificationsLocalDataSource _dataSource;

  @override
  List<AppNotification> getNotificationsForPatient(String patientId) {
    return _dataSource.getNotificationsForPatient(patientId);
  }

  @override
  int getUnreadCountForPatient(String patientId) {
    return _dataSource.getUnreadCountForPatient(patientId);
  }

  @override
  void markAsRead(String notificationId) {
    _dataSource.markAsRead(notificationId);
  }

  @override
  AppNotification addNotification({
    required String patientId,
    required AppNotificationType type,
    required String title,
    required String description,
    String? actionRoute,
    Object? actionExtra,
  }) {
    return _dataSource.addNotification(
      patientId: patientId,
      type: type,
      title: title,
      description: description,
      actionRoute: actionRoute,
      actionExtra: actionExtra,
    );
  }
}
