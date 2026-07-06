import '../../../../core/constants/app_routes.dart';
import '../../domain/entities/app_notification.dart';

class NotificationsLocalDataSource {
  NotificationsLocalDataSource._();

  static final NotificationsLocalDataSource instance =
      NotificationsLocalDataSource._();

  int _nextId = 100;

  final Map<String, List<AppNotification>> _notificationsByPatient = {
    'p1': [
      const AppNotification(
        id: 'n1',
        patientId: 'p1',
        type: AppNotificationType.appointment,
        title: 'تم تأكيد موعدك القادم',
        description: 'موعدك مع د. سارة منصور اليوم الساعة 09:30 صباحًا.',
        timeLabel: 'منذ 10 دقائق',
        isRead: false,
        actionRoute: AppRoutes.patientAppointments,
      ),
      const AppNotification(
        id: 'n2',
        patientId: 'p1',
        type: AppNotificationType.labResult,
        title: 'تمت إضافة نتيجة تحليل جديدة',
        description: 'نتيجة CBC أصبحت متاحة داخل قسم التحاليل.',
        timeLabel: 'أمس',
        isRead: true,
        actionRoute: AppRoutes.patientLaboratory,
      ),
      const AppNotification(
        id: 'n3',
        patientId: 'p1',
        type: AppNotificationType.general,
        title: 'تذكير صحي',
        description: 'لا تنس متابعة قياساتك الصحية الأسبوعية.',
        timeLabel: 'أمس',
        isRead: true,
      ),
    ],
  };

  List<AppNotification> getNotificationsForPatient(String patientId) {
    final list = _notificationsByPatient[patientId];
    if (list == null) return const [];
    // Most recent first.
    return List.unmodifiable(list.reversed);
  }

  int getUnreadCountForPatient(String patientId) {
    final list = _notificationsByPatient[patientId] ?? const [];
    return list.where((n) => !n.isRead).length;
  }

  void markAsRead(String notificationId) {
    for (final entry in _notificationsByPatient.entries) {
      final index = entry.value.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        entry.value[index] = entry.value[index].copyWith(isRead: true);
        return;
      }
    }
  }

  AppNotification addNotification({
    required String patientId,
    required AppNotificationType type,
    required String title,
    required String description,
    String? actionRoute,
    Object? actionExtra,
  }) {
    final notification = AppNotification(
      id: 'n${_nextId++}',
      patientId: patientId,
      type: type,
      title: title,
      description: description,
      timeLabel: 'الآن',
      isRead: false,
      actionRoute: actionRoute,
      actionExtra: actionExtra,
    );
    final list = _notificationsByPatient.putIfAbsent(patientId, () => []);
    list.add(notification);
    return notification;
  }
}
