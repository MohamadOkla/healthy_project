import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';

class DoctorBottomNavigation extends StatelessWidget {
  const DoctorBottomNavigation({super.key, required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.08),
          ),
          boxShadow: theme.colorScheme.brightness == Brightness.dark
              ? null
              : AppShadows.medium,
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 76,
          indicatorColor: AppColors.primary.withValues(alpha: 0.12),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_rounded),
              selectedIcon: Icon(
                Icons.dashboard_rounded,
                color: AppColors.primary,
              ),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.group_rounded),
              selectedIcon: Icon(Icons.group_rounded, color: AppColors.primary),
              label: 'المرضى',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_rounded),
              selectedIcon: Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primary,
              ),
              label: 'الجدول',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_rounded),
              selectedIcon: Icon(
                Icons.notifications_rounded,
                color: AppColors.primary,
              ),
              label: 'الإشعارات',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_rounded),
              selectedIcon: Icon(
                Icons.person_rounded,
                color: AppColors.primary,
              ),
              label: 'حسابي',
            ),
          ],
          onDestinationSelected: (index) {
            if (index == selectedIndex) {
              return;
            }

            if (index == 0) {
              context.go(AppRoutes.doctor);
            } else if (index == 1) {
              context.go(AppRoutes.doctorPatients);
            } else if (index == 2) {
              context.go(AppRoutes.doctorAppointments);
            } else if (index == 3) {
              context.go(AppRoutes.doctorConsultations);
            } else if (index == 4) {
              context.go(AppRoutes.doctorProfile);
            }
          },
        ),
      ),
    );
  }
}
