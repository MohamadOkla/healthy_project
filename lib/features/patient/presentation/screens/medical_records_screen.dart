import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/current_patient.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../laboratory/data/repositories/laboratory_repository_impl.dart';
import '../../../medical_records/data/repositories/medical_records_repository_impl.dart';
import '../../../prescriptions/data/repositories/prescriptions_repository_impl.dart';
import '../widgets/patient_bottom_navigation.dart';

class MedicalRecordsScreen extends StatelessWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = MedicalRecordsRepositoryImpl()
        .getRecordsForPatient(currentPatientId);

    return _PatientListScreen(
      title: 'السجل الطبي',
      selectedIndex: 0,
      emptyTitle: 'لا توجد سجلات طبية بعد',
      emptyMessage: 'ستظهر هنا زياراتك الطبية بعد أن يضيفها طبيبك.',
      emptyIcon: Icons.assignment_outlined,
      children: records
          .map(
            (record) => _ListCard(
              icon: Icons.assignment_rounded,
              title: record.diagnosis,
              subtitle: '${record.doctorName} · ${record.specialty}',
              trailing: record.visitDate,
              onTap: () => context.go(
                AppRoutes.patientMedicalRecordDetails,
                extra: record,
              ),
            ),
          )
          .toList(),
    );
  }
}

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prescriptions = PrescriptionsRepositoryImpl()
        .getPrescriptionsForPatient(currentPatientId);

    return _PatientListScreen(
      title: 'الوصفات',
      selectedIndex: 0,
      emptyTitle: 'لا توجد وصفات بعد',
      emptyMessage: 'ستظهر هنا الوصفات التي يصدرها طبيبك.',
      emptyIcon: Icons.medication_outlined,
      children: prescriptions
          .map(
            (prescription) => _ListCard(
              icon: Icons.medication_rounded,
              title: prescription.medicines.isEmpty
                  ? 'وصفة طبية'
                  : prescription.medicines.first.name,
              subtitle: prescription.medicines.length > 1
                  ? 'و ${prescription.medicines.length - 1} أدوية أخرى'
                  : prescription.medicines.isEmpty
                      ? ''
                      : prescription.medicines.first.frequency,
              trailing: prescription.isActive ? 'نشطة' : 'سابقة',
              onTap: () => context.go(
                AppRoutes.patientPrescriptionDetails,
                extra: prescription,
              ),
            ),
          )
          .toList(),
    );
  }
}

class LaboratoryResultsScreen extends StatelessWidget {
  const LaboratoryResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final results =
        LaboratoryRepositoryImpl().getResultsForPatient(currentPatientId);

    return _PatientListScreen(
      title: 'التحاليل',
      selectedIndex: 0,
      emptyTitle: 'لا توجد نتائج تحاليل بعد',
      emptyMessage: 'ستظهر هنا نتائج التحاليل المخبرية عند توفرها.',
      emptyIcon: Icons.science_outlined,
      children: results
          .map(
            (result) => _ListCard(
              icon: Icons.science_rounded,
              title: result.testName,
              subtitle: result.labName,
              trailing: result.testDate,
              onTap: () => context.go(
                AppRoutes.patientLaboratoryDetails,
                extra: result,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PatientListScreen extends StatelessWidget {
  const _PatientListScreen({
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

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.10),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium(context)),
                if (subtitle.isNotEmpty)
                  Text(subtitle, style: AppTextStyles.bodyMedium(context)),
              ],
            ),
          ),
          Text(trailing, style: AppTextStyles.bodyMedium(context)),
          const Icon(Icons.chevron_left_rounded),
        ],
      ),
    );
  }
}
