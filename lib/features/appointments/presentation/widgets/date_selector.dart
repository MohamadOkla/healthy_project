import 'package:flutter/material.dart';

import '../../data/doctor_leave.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.leaves = const [],
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final List<DoctorLeave> leaves;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dates =
        List.generate(14, (index) => today.add(Duration(days: index)));

    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = selectedDate != null &&
              selectedDate!.year == date.year &&
              selectedDate!.month == date.month &&
              selectedDate!.day == date.day;
          return _DateItem(
            date: date,
            isSelected: isSelected,
            isOnLeave: leaves.any((leave) => leave.includes(date)),
            onTap: () => onDateSelected(date),
          );
        },
      ),
    );
  }
}

class _DateItem extends StatelessWidget {
  const _DateItem({
    required this.date,
    required this.isSelected,
    required this.isOnLeave,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isOnLeave;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const days = ['إثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت', 'أحد'];
    final dayName = days[date.weekday - 1];
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: AnimatedContainer(
        width: isOnLeave ? 94 : 82,
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isOnLeave
                  ? AppColors.error.withValues(alpha: 0.07)
                  : context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isOnLeave
                    ? AppColors.error.withValues(alpha: 0.38)
                    : AppColors.textGrey.withValues(alpha: 0.16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: AppTextStyles.bodyMedium(context).copyWith(
                color:
                    isSelected ? AppColors.white : context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              date.day.toString(),
              style: AppTextStyles.titleMedium(context).copyWith(
                color:
                    isSelected ? AppColors.white : context.colors.textPrimary,
              ),
            ),
            if (isOnLeave) ...[
              const SizedBox(height: 2),
              Text(
                'إجازة',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  fontSize: 11,
                  color: isSelected ? AppColors.white : AppColors.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
