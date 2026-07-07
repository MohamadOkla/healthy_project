import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../notifications/domain/entities/app_notification.dart';
import 'notifications_screen.dart' show iconForNotificationType;

const _fallbackNotification = AppNotification(
  id: 'n0',
  patientId: 'p1',
  type: AppNotificationType.appointment,
  title: 'تم تأكيد موعدك القادم',
  description: 'موعدك مع طبيبك في انتظار التفاصيل.',
  timeLabel: '',
  isRead: true,
);

class NotificationDetailsScreen extends StatelessWidget {
  const NotificationDetailsScreen({super.key, this.notification});

  final AppNotification? notification;

  @override
  Widget build(BuildContext context) {
    final notification = this.notification ?? _fallbackNotification;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientNotifications),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('تفاصيل الإشعار'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primaryTint,
                  child: Icon(
                    iconForNotificationType(notification.type),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  notification.title,
                  style: AppTextStyles.headlineLarge(context),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  notification.description,
                  style: AppTextStyles.bodyMedium(context),
                ),
                if (notification.timeLabel.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    notification.timeLabel,
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (notification.actionRoute != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              text: 'عرض التفاصيل',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => context.go(
                notification.actionRoute!,
                extra: notification.actionExtra,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
