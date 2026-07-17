import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../data/repositories/hospital_admin_repository_impl.dart';
import '../../domain/entities/hospital_doctor.dart';
import '../widgets/hospital_doctor_info_row.dart';
import '../widgets/hospital_doctor_stat_tile.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/repositories/hospital_admin_repository.dart';

class HospitalDoctorDetailScreen extends StatefulWidget {
  const HospitalDoctorDetailScreen({
    super.key,
    required this.doctorId,
    this.repository,
  });

  final String doctorId;
  final HospitalAdminRepository? repository;

  @override
  State<HospitalDoctorDetailScreen> createState() =>
      _HospitalDoctorDetailScreenState();
}

class _HospitalDoctorDetailScreenState
    extends State<HospitalDoctorDetailScreen> {
  late final HospitalAdminRepository _repository =
      widget.repository ?? HospitalAdminRepositoryImpl();
  HospitalDoctor? _doctor;

  @override
  void initState() {
    super.initState();
    _doctor = _repository.getDoctorById(widget.doctorId);
  }

  void _toggleStatus() {
    final doctor = _doctor;
    if (doctor == null) return;
    final newStatus = doctor.status == HospitalDoctorStatus.active
        ? HospitalDoctorStatus.onLeave
        : HospitalDoctorStatus.active;
    _repository.setDoctorStatus(doctor.id, newStatus);
    setState(() {
      _doctor = _repository.getDoctorById(widget.doctorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctor = _doctor;

    return Scaffold(
      appBar: AppBar(
        title: Text(doctor?.name ?? 'ملف الطبيب'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.hospitalAdminDoctors),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: doctor == null
          ? const AppEmptyState(
              title: 'تعذر إيجاد بيانات الطبيب',
              icon: Icons.person_off_rounded,
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AppCard(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.12),
                        child: Text(
                          doctor.initials,
                          style: AppTextStyles.headlineLarge(context).copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(doctor.name, style: AppTextStyles.headlineLarge(context)),
                      const SizedBox(height: AppSpacing.xs),
                      Text(doctor.specialty, style: AppTextStyles.bodyMedium(context)),
                      const SizedBox(height: AppSpacing.md),
                      HospitalDoctorInfoRow(icon: Icons.phone_rounded, value: doctor.phone),
                      HospitalDoctorInfoRow(
                        icon: Icons.email_outlined,
                        value: doctor.email,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: HospitalDoctorStatTile(
                        label: 'عدد المرضى',
                        value: '${doctor.patientsCount}',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: HospitalDoctorStatTile(
                        label: 'مواعيد اليوم',
                        value: '${doctor.todayAppointmentsCount}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  text: doctor.status == HospitalDoctorStatus.active
                      ? 'تعيين كـ"إجازة"'
                      : 'تعيين كـ"نشط"',
                  icon: doctor.status == HospitalDoctorStatus.active
                      ? Icons.beach_access_rounded
                      : Icons.verified_user_rounded,
                  isOutlined: true,
                  onPressed: _toggleStatus,
                ),
              ],
            ),
    );
  }
}
