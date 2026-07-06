import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/current_patient.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../notifications/data/repositories/notifications_repository_impl.dart';
import '../../../notifications/domain/entities/app_notification.dart';
import '../widgets/notification_card.dart';
import '../widgets/patient_bottom_navigation.dart';

IconData iconForNotificationType(AppNotificationType type) {
  switch (type) {
    case AppNotificationType.appointment:
      return Icons.notifications_active_rounded;
    case AppNotificationType.prescription:
      return Icons.medication_rounded;
    case AppNotificationType.labResult:
      return Icons.science_rounded;
    case AppNotificationType.medicalRecord:
      return Icons.assignment_rounded;
    case AppNotificationType.general:
      return Icons.health_and_safety_rounded;
  }
}

Color colorForNotificationType(AppNotificationType type) {
  switch (type) {
    case AppNotificationType.appointment:
      return AppColors.primary;
    case AppNotificationType.prescription:
      return AppColors.secondary;
    case AppNotificationType.labResult:
      return AppColors.warning;
    case AppNotificationType.medicalRecord:
      return const Color(0xFF0891B2);
    case AppNotificationType.general:
      return AppColors.success;
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _repository = NotificationsRepositoryImpl();
  late List<AppNotification> _notifications =
      _repository.getNotificationsForPatient(currentPatientId);

  void _openNotification(AppNotification notification) {
    _repository.markAsRead(notification.id);
    setState(() {
      _notifications = _repository.getNotificationsForPatient(
        currentPatientId,
      );
    });
    context.go(AppRoutes.patientNotificationDetails, extra: notification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientDashboard),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('الإشعارات'),
      ),
      body: _notifications.isEmpty
          ? const AppEmptyState(
              title: 'لا توجد إشعارات',
              message: 'ستظهر التنبيهات الطبية المهمة هنا عند توفرها.',
              icon: Icons.notifications_off_rounded,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return NotificationCard(
                  icon: iconForNotificationType(notification.type),
                  title: notification.title,
                  description: notification.description,
                  time: notification.timeLabel,
                  isRead: notification.isRead,
                  color: colorForNotificationType(notification.type),
                  onTap: () => _openNotification(notification),
                );
              },
            ),
      bottomNavigationBar: const PatientBottomNavigation(selectedIndex: 3),
    );
  }
}
