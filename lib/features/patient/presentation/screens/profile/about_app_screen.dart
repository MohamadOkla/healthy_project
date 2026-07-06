import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_card.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientProfile),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('حول التطبيق'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                const Icon(
                  Icons.health_and_safety_rounded,
                  color: AppColors.primary,
                  size: 64,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(AppStrings.appNameAr, style: AppTextStyles.headlineLarge),
                const SizedBox(height: AppSpacing.sm),
                Text('الإصدار 1.0.0', style: AppTextStyles.bodyMedium),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'منظومة رقمية لإدارة الخدمات الطبية وربط المرضى بالخدمات الصحية بسهولة وأمان.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Text('وزارة الصحة', style: AppTextStyles.titleMedium),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            text: 'عرض التراخيص',
            icon: Icons.article_rounded,
            onPressed: () => showLicensePage(
              context: context,
              applicationName: 'Digital Health System',
              applicationVersion: '1.0.0',
            ),
          ),
        ],
      ),
    );
  }
}
