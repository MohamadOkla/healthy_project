import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../models/doctor_ui_model.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.isSelected,
    required this.onTap,
    this.earliestAvailable,
    this.leaveNotice,
    this.onDetailsTap,
  });

  final DoctorUiModel doctor;
  final bool isSelected;
  final VoidCallback onTap;
  final String? earliestAvailable;
  final String? leaveNotice;
  final VoidCallback? onDetailsTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isSelected ? 1.02 : 1,
      duration: const Duration(milliseconds: 180),
      child: AppCard(
        onTap: onTap,
        showShadow: isSelected,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(doctor.icon, color: AppColors.primary, size: 30),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.name, style: AppTextStyles.titleMedium(context)),
                  Text(
                    '${doctor.specialty} • ${doctor.hospital}',
                    style: AppTextStyles.bodyMedium(context),
                  ),
                  if (leaveNotice != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.event_busy_rounded,
                              size: 16, color: AppColors.warning),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              leaveNotice!,
                              style: AppTextStyles.bodyMedium(context).copyWith(
                                color: context.colors.textPrimary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _Meta(
                          icon: Icons.star_rounded,
                          label: doctor.rating.toString()),
                      _Meta(
                          icon: Icons.work_history_rounded,
                          label: doctor.experience),
                      _Meta(
                        icon: Icons.schedule_rounded,
                        label: earliestAvailable ??
                            'لا توجد مواعيد ضمن الأسبوعين القادمين',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onDetailsTap != null)
                  IconButton(
                    tooltip: 'تفاصيل الطبيب',
                    visualDensity: VisualDensity.compact,
                    onPressed: onDetailsTap,
                    icon: const Icon(Icons.info_outline_rounded),
                  ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: isSelected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          key: ValueKey('selected'),
                          color: AppColors.primary,
                        )
                      : Icon(
                          Icons.radio_button_unchecked_rounded,
                          key: const ValueKey('idle'),
                          color: context.colors.textSecondary,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.warning),
        const SizedBox(width: AppSpacing.xs),
        Text(label,
            style: AppTextStyles.bodyMedium(context).copyWith(fontSize: 12)),
      ],
    );
  }
}
