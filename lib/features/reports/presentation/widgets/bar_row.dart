import 'package:flutter/material.dart';
import 'bar_chart_item.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class BarRow extends StatelessWidget {
  const BarRow({required this.bar, required this.maxValue});

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
              child: Text(bar.label, style: AppTextStyles.bodyMedium(context)),
            ),
            Text(
              '${bar.value}',
              style: AppTextStyles.bodyMedium(context).copyWith(
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
