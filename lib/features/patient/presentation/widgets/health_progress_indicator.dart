import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HealthProgressIndicator extends StatelessWidget {
  const HealthProgressIndicator({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'مؤشر الصحة ${(value * 100).round()} بالمئة',
      child: SizedBox.square(
        dimension: 86,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: value,
              strokeWidth: 9,
              backgroundColor: AppColors.primary.withValues(alpha: 0.16),
              color: AppColors.primary,
            ),
            Text(
              '${(value * 100).round()}%',
              style: AppTextStyles.titleMedium(context),
            ),
          ],
        ),
      ),
    );
  }
}
