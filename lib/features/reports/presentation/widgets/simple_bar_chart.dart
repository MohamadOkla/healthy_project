import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

class BarChartItem {
  const BarChartItem({
    required this.label,
    required this.value,
    this.color = AppColors.primary,
  });

  final String label;
  final int value;
  final Color color;
}

/// A minimal horizontal bar chart built from plain widgets (no charting
/// package dependency). Bar widths are proportional to [BarChartItem.value]
/// relative to the largest value in the list.
class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({
    super.key,
    required this.title,
    required this.bars,
    this.emptyMessage = 'لا توجد بيانات بعد',
  });

  final String title;
  final List<BarChartItem> bars;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final highestValue = bars.isEmpty
        ? 0
        : bars.map((bar) => bar.value).reduce((a, b) => a > b ? a : b);
    final maxValue = highestValue < 1 ? 1 : highestValue;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSpacing.md),
          if (bars.isEmpty)
            Text(emptyMessage, style: AppTextStyles.bodyMedium)
          else
            ...bars.map(
              (bar) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _BarRow(bar: bar, maxValue: maxValue),
              ),
            ),
        ],
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  const _BarRow({required this.bar, required this.maxValue});

  final BarChartItem bar;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    final fraction = bar.value / maxValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(bar.label, style: AppTextStyles.bodyMedium),
            ),
            Text(
              '${bar.value}',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w800,
                color: bar.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 10,
                    width: constraints.maxWidth,
                    color: bar.color.withValues(alpha: 0.10),
                  ),
                  Container(
                    height: 10,
                    width: constraints.maxWidth * fraction.clamp(0.0, 1.0),
                    color: bar.color,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
