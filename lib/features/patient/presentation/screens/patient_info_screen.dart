import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';

class PatientInfoScreen extends StatelessWidget {
  const PatientInfoScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.backRoute = AppRoutes.patientProfile,
    this.actionText,
    this.actionRoute,
  });

  final String title;
  final String description;
  final IconData icon;
  final String backRoute;
  final String? actionText;
  final String? actionRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(backRoute),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: AppCard(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                    child: Icon(icon, color: AppColors.primary, size: 38),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headlineLarge(context),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium(context),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'هذه واجهة مؤقتة قابلة للتوسعة عند ربط الخدمات الفعلية.',
                            style: AppTextStyles.bodyMedium(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (actionText != null && actionRoute != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      text: actionText!,
                      icon: Icons.arrow_back_rounded,
                      onPressed: () => context.go(actionRoute!),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
