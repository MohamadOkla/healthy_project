import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/appointment_status.dart';

class AppointmentTabs extends StatelessWidget {
  const AppointmentTabs({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  final AppointmentStatus selectedStatus;
  final ValueChanged<AppointmentStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = {
      AppointmentStatus.confirmed: 'القادمة',
      AppointmentStatus.completed: 'السابقة',
      AppointmentStatus.canceled: 'الملغاة',
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.textGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: tabs.entries.map((entry) {
          final isSelected = selectedStatus == entry.key;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              decoration: BoxDecoration(
                color: isSelected ? context.colors.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: TextButton(
                onPressed: () => onChanged(entry.key),
                child: Text(
                  entry.value,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : context.colors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
