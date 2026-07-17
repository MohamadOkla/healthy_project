import 'package:flutter/material.dart';
import '../cubit/appointments_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class ActiveFiltersSummary extends StatelessWidget {
  const ActiveFiltersSummary({required this.state});

  final AppointmentsState state;

  @override
  Widget build(BuildContext context) {
    final labels = [
      if (state.searchQuery.isNotEmpty) 'بحث: ${state.searchQuery}',
      if (state.specialtyFilter != null) 'اختصاص: ${state.specialtyFilter}',
      if (state.dateFilter != null) 'تاريخ: ${state.dateFilter}',
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: labels
          .map(
            (label) => Chip(
              label: Text(label),
              backgroundColor: AppColors.primary.withValues(alpha: 0.10),
            ),
          )
          .toList(),
    );
  }
}
