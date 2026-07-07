import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/time_slot_ui_model.dart';

class TimeSlotGrid extends StatelessWidget {
  const TimeSlotGrid({
    super.key,
    required this.title,
    required this.slots,
    required this.selectedTime,
    required this.onSelected,
  });

  final String title;
  final List<TimeSlotUiModel> slots;
  final String? selectedTime;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMedium(context)),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          itemCount: slots.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 2.4,
          ),
          itemBuilder: (context, index) {
            final slot = slots[index];
            final fullLabel = '${slot.label} ${slot.period}';
            final isSelected = selectedTime == fullLabel;
            return OutlinedButton(
              onPressed: slot.isAvailable ? () => onSelected(fullLabel) : null,
              style: OutlinedButton.styleFrom(
                backgroundColor:
                    isSelected ? AppColors.primary : context.colors.surface,
                foregroundColor:
                    isSelected ? AppColors.white : context.colors.textPrimary,
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textGrey.withValues(alpha: 0.18),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text(fullLabel, textAlign: TextAlign.center),
            );
          },
        ),
      ],
    );
  }
}
