import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/patient_bottom_navigation.dart';
import '../widgets/patient_logout_dialog.dart';
import '../widgets/profile_section_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientDashboard),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('حسابي'),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _ProfileHeader(state: state),
              const SizedBox(height: AppSpacing.lg),
              ProfileSectionCard(
                title: 'الحساب',
                items: [
                  ProfileSectionItem(
                    icon: Icons.edit_rounded,
                    title: 'تعديل الملف الشخصي',
                    onTap: () => context.go(AppRoutes.patientEditProfile),
                  ),
                  ProfileSectionItem(
                    icon: Icons.lock_reset_rounded,
                    title: 'تغيير كلمة المرور',
                    onTap: () => context.go(AppRoutes.patientChangePassword),
                  ),
                  ProfileSectionItem(
                    icon: Icons.notifications_active_rounded,
                    title: 'إعدادات الإشعارات',
                    onTap: () =>
                        context.go(AppRoutes.patientNotificationSettings),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ProfileSectionCard(
                title: 'المعلومات الصحية',
                items: [
                  ProfileSectionItem(
                    icon: Icons.bloodtype_rounded,
                    title: 'فصيلة الدم',
                    subtitle: state.bloodType,
                    onTap: () => context.go(AppRoutes.patientHealthInfo),
                  ),
                  ProfileSectionItem(
                    icon: Icons.cake_rounded,
                    title: 'العمر',
                    subtitle: state.age,
                    onTap: () => context.go(AppRoutes.patientHealthInfo),
                  ),
                  ProfileSectionItem(
                    icon: Icons.wc_rounded,
                    title: 'الجنس',
                    subtitle: state.gender,
                    onTap: () => context.go(AppRoutes.patientHealthInfo),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ProfileSectionCard(
                title: 'التطبيق',
                items: [
                  ProfileSectionItem(
                    icon: Icons.language_rounded,
                    title: 'اللغة',
                    subtitle: state.language,
                    onTap: () => context.go(AppRoutes.patientLanguage),
                  ),
                  ProfileSectionItem(
                    icon: Icons.help_outline_rounded,
                    title: 'المساعدة',
                    onTap: () => context.go(AppRoutes.patientHelp),
                  ),
                  ProfileSectionItem(
                    icon: Icons.info_outline_rounded,
                    title: 'حول التطبيق',
                    onTap: () => context.go(AppRoutes.patientAbout),
                  ),
                  ProfileSectionItem(
                    icon: Icons.privacy_tip_rounded,
                    title: 'سياسة الخصوصية',
                    onTap: () => context.go(AppRoutes.patientProfilePrivacy),
                  ),
                  ProfileSectionItem(
                    icon: Icons.gavel_rounded,
                    title: 'شروط الاستخدام',
                    onTap: () => context.go(AppRoutes.patientProfileTerms),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                text: 'تسجيل الخروج',
                icon: Icons.logout_rounded,
                isOutlined: true,
                onPressed: () => showPatientLogoutDialog(context),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          );
        },
      ),
      bottomNavigationBar: const PatientBottomNavigation(selectedIndex: 4),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.state});

  final ProfileState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => context.go(AppRoutes.patientEditProfile),
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            borderRadius: BorderRadius.circular(68),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.white,
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 54,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            state.fullName,
            style: AppTextStyles.headlineLarge(context).copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ProfileInfoChip(icon: Icons.email_outlined, value: state.email),
          const SizedBox(height: AppSpacing.sm),
          _ProfileInfoChip(icon: Icons.phone_rounded, value: state.phone),
        ],
      ),
    );
  }
}

class _ProfileInfoChip extends StatelessWidget {
  const _ProfileInfoChip({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium(context),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
