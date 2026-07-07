import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.title,
    this.message,
    this.onRetry,
    this.retryText = 'إعادة المحاولة',
  });

  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final String retryText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: AppSizes.iconXl,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(title,
                style: AppTextStyles.titleMedium(context), textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(message!,
                  style: AppTextStyles.bodyMedium(context), textAlign: TextAlign.center),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(text: retryText, onPressed: onRetry, expand: false),
            ],
          ],
        ),
      ),
    );
  }
}
