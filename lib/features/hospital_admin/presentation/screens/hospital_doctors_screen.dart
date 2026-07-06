import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/repositories/hospital_admin_repository_impl.dart';
import '../../domain/entities/hospital_doctor.dart';
import '../../domain/repositories/hospital_admin_repository.dart';
import '../widgets/hospital_admin_bottom_navigation.dart';
import '../widgets/hospital_doctor_tile.dart';

const List<Color> _accentPalette = [
  AppColors.primary,
  Color(0xFF2563EB),
  Color(0xFF7C3AED),
  Color(0xFFEA580C),
  Color(0xFF0891B2),
  AppColors.success,
];

class HospitalDoctorsScreen extends StatefulWidget {
  const HospitalDoctorsScreen({super.key, this.repository});

  final HospitalAdminRepository? repository;

  @override
  State<HospitalDoctorsScreen> createState() => _HospitalDoctorsScreenState();
}

class _HospitalDoctorsScreenState extends State<HospitalDoctorsScreen> {
  late final HospitalAdminRepository _repository =
      widget.repository ?? HospitalAdminRepositoryImpl();
  late final List<HospitalDoctor> _allDoctors = _repository.getDoctors();
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
    final visibleDoctors = query.isEmpty
        ? _allDoctors
        : _allDoctors
            .where(
              (doctor) =>
                  doctor.name.toLowerCase().contains(query) ||
                  doctor.specialty.toLowerCase().contains(query),
            )
            .toList(growable: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('الأطباء'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.hospitalAdmin),
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
              hint: 'ابحث باسم الطبيب أو الاختصاص',
              prefixIcon: const Icon(Icons.search_rounded),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${visibleDoctors.length} من ${_allDoctors.length} طبيب',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: visibleDoctors.isEmpty
                  ? const AppEmptyState(
                      title: 'لا يوجد نتائج',
                      message: 'جرّب كلمة بحث مختلفة.',
                      icon: Icons.search_off_rounded,
                    )
                  : ListView.separated(
                      itemCount: visibleDoctors.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final doctor = visibleDoctors[index];
                        return HospitalDoctorTile(
                          doctor: doctor,
                          accentColor:
                              _accentPalette[index % _accentPalette.length],
                          onTap: () => context.go(
                            AppRoutes.hospitalAdminDoctorDetail,
                            extra: doctor.id,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const HospitalAdminBottomNavigation(selectedIndex: 1),
    );
  }
}
