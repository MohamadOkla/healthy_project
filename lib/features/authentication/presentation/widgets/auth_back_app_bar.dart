import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthBackAppBar extends StatelessWidget {
  const AuthBackAppBar({
    super.key,
    required this.title,
    required this.onBackPressed,
  });

  final String title;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        children: [
          Material(
            color: AppColors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: IconButton(
              tooltip: 'رجوع',
              onPressed: onBackPressed,
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.titleMedium(context).copyWith(color: AppColors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
