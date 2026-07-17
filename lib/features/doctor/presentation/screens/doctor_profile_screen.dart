import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/doctor_bottom_navigation.dart';
import '../widgets/doctor_logout_dialog.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.doctor),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('حسابي'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    color: AppColors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('د. سارة منصور', style: AppTextStyles.headlineLarge(context)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'طب عام · مشفى دمشق الجامعي',
                  style: AppTextStyles.bodyMedium(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            text: 'تسجيل الخروج',
            icon: Icons.logout_rounded,
            isOutlined: true,
            onPressed: () => showDoctorLogoutDialog(context),
          ),
        ],
      ),
      bottomNavigationBar: const DoctorBottomNavigation(selectedIndex: 4),
    );
  }
}
