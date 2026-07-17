import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/repositories/doctor_repository_impl.dart';
import '../../domain/entities/patient_summary.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../widgets/doctor_bottom_navigation.dart';
import '../widgets/patient_tile.dart';

const List<Color> _accentPalette = AppColors.accentPalette;

class DoctorPatientsScreen extends StatefulWidget {
  const DoctorPatientsScreen({super.key, this.repository});

  final DoctorRepository? repository;

  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  late final DoctorRepository _repository =
      widget.repository ?? DoctorRepositoryImpl();
  late final List<PatientSummary> _allPatients = _repository.getPatients();
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final visiblePatients = query.isEmpty
        ? _allPatients
        : _allPatients
            .where(
              (patient) =>
                  patient.name.toLowerCase().contains(query) ||
                  patient.primaryDiagnosis.toLowerCase().contains(query),
            )
            .toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('مرضاي'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.doctor),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _searchController,
              hint: 'ابحث باسم المريض أو التشخيص',
              prefixIcon: const Icon(Icons.search_rounded),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${visiblePatients.length} من ${_allPatients.length} مريض',
              style: AppTextStyles.bodyMedium(context),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: visiblePatients.isEmpty
                  ? const AppEmptyState(
                      title: 'لا يوجد نتائج',
                      message: 'جرّب كلمة بحث مختلفة.',
                      icon: Icons.search_off_rounded,
                    )
                  : ListView.separated(
                      itemCount: visiblePatients.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final patient = visiblePatients[index];
                        final accentColor =
                            _accentPalette[index % _accentPalette.length];
                        return PatientTile(
                          name: patient.name,
                          age: patient.age,
                          lastVisit: patient.lastVisitLabel,
                          diagnosis: patient.primaryDiagnosis,
                          initials: patient.initials,
                          accentColor: accentColor,
                          onTap: () => context.go(
                            AppRoutes.doctorPatientDetail,
                            extra: patient.id,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const DoctorBottomNavigation(selectedIndex: 1),
    );
  }
}
