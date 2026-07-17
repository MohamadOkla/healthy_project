import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/profile_cubit.dart';
import 'patient_logout_dialog.dart';

class PatientDrawer extends StatelessWidget {
  const PatientDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileCubit>().state;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.22),
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.white,
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.fullName,
                          style: AppTextStyles.titleMedium(context).copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          profile.email,
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: AppColors.white.withValues(alpha: 0.86),
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                children: [
                  _DrawerItem(
                    icon: Icons.home_rounded,
                    title: 'الرئيسية',
                    route: AppRoutes.patientDashboard,
                  ),
                  _DrawerItem(
                    icon: Icons.calendar_month_rounded,
                    title: 'مواعيدي',
                    route: AppRoutes.patientAppointments,
                  ),
                  _DrawerItem(
                    icon: Icons.assignment_rounded,
                    title: 'السجل الطبي',
                    route: AppRoutes.patientMedicalRecords,
                  ),
                  _DrawerItem(
                    icon: Icons.medication_rounded,
                    title: 'الوصفات',
                    route: AppRoutes.patientPrescriptions,
                  ),
                  _DrawerItem(
                    icon: Icons.science_rounded,
                    title: 'التحاليل',
                    route: AppRoutes.patientLaboratory,
                  ),
                  _DrawerItem(
                    icon: Icons.notifications_rounded,
                    title: 'الإشعارات',
                    route: AppRoutes.patientNotifications,
                  ),
                  _DrawerItem(
                    icon: Icons.person_rounded,
                    title: 'حسابي',
                    route: AppRoutes.patientProfile,
                  ),
                  _DrawerItem(
                    icon: Icons.settings_rounded,
                    title: 'الإعدادات',
                    route: AppRoutes.patientSettings,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Material(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                  ),
                  title: Text(
                    'تسجيل الخروج',
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onTap: () => showPatientLogoutDialog(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 21),
          ),
          title: Text(
            title,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_left_rounded,
            color: AppColors.primary,
          ),
          onTap: () => context.go(route),
        ),
      ),
    );
  }
}
