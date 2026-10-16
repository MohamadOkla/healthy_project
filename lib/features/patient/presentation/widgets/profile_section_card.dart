import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<ProfileSectionItem> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium(context).copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...items.map(
            (item) => Material(
              // ListTile paints its ink reactions on the nearest Material.
              // AppCard is a decorated Container, so provide that surface here.
              color: Colors.transparent,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: AppColors.primary, size: 22),
                ),
                title:
                    Text(item.title, style: AppTextStyles.bodyMedium(context)),
                subtitle: item.subtitle == null
                    ? null
                    : Text(item.subtitle!,
                        style: AppTextStyles.bodyMedium(context)),
                trailing: item.onTap == null
                    ? null
                    : const Icon(Icons.chevron_left_rounded),
                onTap: item.onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSectionItem {
  const ProfileSectionItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
}
