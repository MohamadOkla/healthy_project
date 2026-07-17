import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/patient_bottom_navigation.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_header.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/patient_logout_dialog.dart';

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
              ProfileHeader(state: state),
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
