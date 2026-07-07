import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'quick_action_card.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_QuickActionItem>[
      _QuickActionItem(
        title: 'المرضى',
        icon: Icons.group_rounded,
        color: AppColors.primary,
        onTap: () => context.go(AppRoutes.doctorPatients),
      ),
      _QuickActionItem(
        title: 'المواعيد',
        icon: Icons.event_available_rounded,
        color: const Color(0xFF2563EB),
        onTap: () => context.go(AppRoutes.doctorAppointments),
      ),
      _QuickActionItem(
        title: 'الوصفات',
        icon: Icons.medication_rounded,
        color: const Color(0xFF7C3AED),
        onTap: () => context.go(AppRoutes.doctorPatients),
      ),
      _QuickActionItem(
        title: 'التحاليل',
        icon: Icons.science_rounded,
        color: AppColors.warning,
        onTap: () => context.go(AppRoutes.doctorPatients),
      ),
      _QuickActionItem(
        title: 'السجل الطبي',
        icon: Icons.folder_shared_rounded,
        color: const Color(0xFF0891B2),
        onTap: () => context.go(AppRoutes.doctorPatients),
      ),
      _QuickActionItem(
        title: 'الرسائل',
        icon: Icons.chat_bubble_rounded,
        color: AppColors.success,
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ميزة الرسائل قريبًا')),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إجراءات سريعة',
          style: AppTextStyles.titleMedium(context).copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 2.55,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return QuickActionCard(
              title: item.title,
              icon: item.icon,
              color: item.color,
              onTap: item.onTap,
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionItem {
  const _QuickActionItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}
