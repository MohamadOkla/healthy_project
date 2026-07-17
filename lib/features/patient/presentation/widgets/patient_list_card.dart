import 'package:flutter/material.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class PatientListCard extends StatelessWidget {
  const PatientListCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.10),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium(context)),
                if (subtitle.isNotEmpty)
                  Text(subtitle, style: AppTextStyles.bodyMedium(context)),
              ],
            ),
          ),
          Text(trailing, style: AppTextStyles.bodyMedium(context)),
          const Icon(Icons.chevron_left_rounded),
        ],
      ),
    );
  }
}
