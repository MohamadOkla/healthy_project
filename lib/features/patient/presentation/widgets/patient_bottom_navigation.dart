import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';

class PatientBottomNavigation extends StatelessWidget {
  const PatientBottomNavigation({super.key, required this.selectedIndex});

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
          boxShadow: theme.brightness == Brightness.dark
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
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_rounded),
              selectedIcon: const Icon(
                Icons.home_rounded,
                color: AppColors.primary,
              ),
              label: context.tr('nav_home'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_month_rounded),
              selectedIcon: const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primary,
              ),
              label: context.tr('nav_appointments'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.add_circle_rounded),
              selectedIcon: const Icon(
                Icons.add_circle_rounded,
                color: AppColors.primary,
              ),
              label: context.tr('nav_book'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.notifications_rounded),
              selectedIcon: const Icon(
                Icons.notifications_rounded,
                color: AppColors.primary,
              ),
              label: context.tr('nav_notifications'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_rounded),
              selectedIcon: const Icon(
                Icons.person_rounded,
                color: AppColors.primary,
              ),
              label: context.tr('nav_profile'),
            ),
          ],
          onDestinationSelected: (index) {
            final routes = [
              AppRoutes.patientDashboard,
              AppRoutes.patientAppointments,
              AppRoutes.patientBookAppointment,
              AppRoutes.patientNotifications,
              AppRoutes.patientProfile,
            ];
            final targetRoute = routes[index];
            final currentRoute = GoRouterState.of(context).uri.path;
            if (currentRoute == targetRoute) {
              return;
            }
            context.go(targetRoute);
          },
        ),
      ),
    );
  }
}
