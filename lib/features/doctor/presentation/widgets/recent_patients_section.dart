import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/patient_summary.dart';
import 'patient_tile.dart';

const List<Color> _accentPalette = [
  AppColors.primary,
  Color(0xFF2563EB),
  Color(0xFF7C3AED),
  Color(0xFFEA580C),
];

class RecentPatientsSection extends StatelessWidget {
  const RecentPatientsSection({super.key, required this.patients});

  /// Most-recent-first; only the first few are shown here (see the full
  /// list on the Patients tab).
  final List<PatientSummary> patients;

  @override
  Widget build(BuildContext context) {
    final visible = patients.take(3).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'مرضى حديثون',
                style: AppTextStyles.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.doctorPatients),
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (visible.isEmpty)
          Text('لا يوجد مرضى بعد', style: AppTextStyles.bodyMedium)
        else
          ListView.separated(
            itemCount: visible.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final patient = visible[index];
              return PatientTile(
                name: patient.name,
                age: patient.age,
                lastVisit: patient.lastVisitLabel,
                diagnosis: patient.primaryDiagnosis,
                initials: patient.initials,
                accentColor: _accentPalette[index % _accentPalette.length],
                onTap: () => context.go(
                  AppRoutes.doctorPatientDetail,
                  extra: patient.id,
                ),
              );
            },
          ),
      ],
    );
  }
}
