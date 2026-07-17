import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import 'bar_chart_item.dart';
import 'bar_row.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

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
          Text(title, style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSpacing.md),
          if (bars.isEmpty)
            Text(emptyMessage, style: AppTextStyles.bodyMedium(context))
          else
            ...bars.map(
              (bar) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: BarRow(bar: bar, maxValue: maxValue),
              ),
            ),
        ],
      ),
    );
  }
}
