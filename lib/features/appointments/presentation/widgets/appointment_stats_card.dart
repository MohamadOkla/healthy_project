import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

class AppointmentStatsCard extends StatelessWidget {
  const AppointmentStatsCard({
    super.key,
    required this.upcoming,
    required this.previous,
    required this.canceled,
  });

  final int upcoming;
  final int previous;
  final int canceled;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: upcoming.toString(),
              label: 'قادمة',
              color: AppColors.primary,
            ),
          ),
          Expanded(
            child: _StatItem(
              value: previous.toString(),
              label: 'سابقة',
              color: AppColors.success,
            ),
          ),
          Expanded(
            child: _StatItem(
              value: canceled.toString(),
              label: 'ملغاة',
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineLarge(context).copyWith(color: color),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTextStyles.bodyMedium(context)),
      ],
    );
  }
}
