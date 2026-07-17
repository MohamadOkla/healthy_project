import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class LabSectionText extends StatelessWidget {
  const LabSectionText({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
                AppTextStyles.titleMedium(context).copyWith(color: AppColors.primary)),
        const SizedBox(height: AppSpacing.sm),
        Text(value, style: AppTextStyles.bodyMedium(context)),
      ],
    );
  }
}
