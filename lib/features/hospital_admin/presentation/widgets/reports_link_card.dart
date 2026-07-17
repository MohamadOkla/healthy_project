import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class ReportsLinkCard extends StatelessWidget {
  const ReportsLinkCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(Icons.bar_chart_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('التقارير', style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: 2),
                Text(
                  'توزيع الأطباء، أعداد المرضى، ومعدل الرد على الاستشارات',
                  style: AppTextStyles.bodyMedium(context),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
        ],
      ),
    );
  }
}
