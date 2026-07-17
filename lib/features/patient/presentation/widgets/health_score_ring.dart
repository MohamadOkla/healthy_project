import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HealthScoreRing extends StatelessWidget {
  const HealthScoreRing({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'مؤشر الصحة ${(value * 100).round()} بالمئة',
      child: SizedBox.square(
        dimension: 88,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: value,
              strokeWidth: 9,
              backgroundColor: AppColors.white.withValues(alpha: 0.18),
              color: AppColors.white,
            ),
            Text(
              '${(value * 100).round()}%',
              style: AppTextStyles.titleMedium(context).copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
