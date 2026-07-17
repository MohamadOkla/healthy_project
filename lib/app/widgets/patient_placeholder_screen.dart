import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/app_button.dart';
import '../../features/patient/presentation/widgets/patient_bottom_navigation.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class PatientPlaceholderScreen extends StatelessWidget {
  const PatientPlaceholderScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.selectedIndex,
  });

  final String title;
  final String description;
  final IconData icon;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientDashboard),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                    child: Icon(icon, color: AppColors.primary, size: 34),
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
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    text: 'العودة للرئيسية',
                    icon: Icons.home_rounded,
                    onPressed: () => context.go(AppRoutes.patientDashboard),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          PatientBottomNavigation(selectedIndex: selectedIndex),
    );
  }
}
