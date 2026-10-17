import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/constants/current_patient.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../notifications/data/repositories/notifications_repository_impl.dart';
import '../cubit/profile_cubit.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final fullName = context.select<ProfileCubit, String>(
      (cubit) => cubit.state.fullName,
    );
    final savedName =
        LocalStorageService.instance.getString(StorageKeys.profileFullName);
    final patientName = savedName == null || fullName.trim().isEmpty
        ? 'المريض'
        : fullName.trim();
    final greeting = context.tr('welcome_greeting');
    final separator =
        Directionality.of(context) == TextDirection.rtl ? '، ' : ', ';
    final unreadNotifications = NotificationsRepositoryImpl()
        .getUnreadCountForPatient(currentPatientId);

    return Row(
      children: [
        InkWell(
          onTap: () => context.go(AppRoutes.patientProfile),
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.white,
              child: Icon(Icons.person_rounded, color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: '$greeting$separator',
                  children: [
                    TextSpan(text: '\u2068$patientName\u2069'),
                  ],
                ),
                style: AppTextStyles.titleMedium(context).copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'نتمنى لك يوماً صحياً سعيداً',
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            _HeaderIconButton(
              icon: Icons.notifications_none_rounded,
              semanticLabel: unreadNotifications > 0
                  ? 'الإشعارات، $unreadNotifications إشعارات جديدة'
                  : 'الإشعارات',
              onPressed: () => context.go(AppRoutes.patientNotifications),
            ),
            if (unreadNotifications > 0)
              PositionedDirectional(
                top: -3,
                end: -3,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.error,
                  ),
                  child: Text(
                    '$unreadNotifications',
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        _HeaderIconButton(
          icon: Icons.menu_rounded,
          semanticLabel: 'القائمة',
          onPressed: () => Scaffold.maybeOf(context)?.openEndDrawer(),
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: IconButton(
          iconSize: AppSizes.iconMd,
          color: AppColors.primary,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          onPressed: onPressed,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
