import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_empty_state.dart';
import 'patient_bottom_navigation.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class PatientListView extends StatelessWidget {
  const PatientListView({
    required this.title,
    required this.children,
    required this.selectedIndex,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.emptyIcon,
  });

  final String title;
  final List<Widget> children;
  final int selectedIndex;
  final String emptyTitle;
  final String emptyMessage;
  final IconData emptyIcon;

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
      body: children.isEmpty
          ? AppEmptyState(
              title: emptyTitle,
              message: emptyMessage,
              icon: emptyIcon,
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Text(title, style: AppTextStyles.headlineLarge(context)),
                const SizedBox(height: AppSpacing.md),
                ...children.map(
                  (child) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: child,
                  ),
                ),
              ],
            ),
      bottomNavigationBar:
          PatientBottomNavigation(selectedIndex: selectedIndex),
    );
  }
}
