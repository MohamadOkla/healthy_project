import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/hospital_admin_bottom_navigation.dart';
import '../widgets/hospital_admin_logout_dialog.dart';

class HospitalAdminProfileScreen extends StatelessWidget {
  const HospitalAdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.hospitalAdmin),
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
                    Icons.local_hospital_rounded,
                    color: AppColors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('مدير المشفى', style: AppTextStyles.headlineLarge(context)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'مشفى دمشق الجامعي',
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
            onPressed: () => showHospitalAdminLogoutDialog(context),
          ),
        ],
      ),
      bottomNavigationBar: const HospitalAdminBottomNavigation(selectedIndex: 2),
    );
  }
}
