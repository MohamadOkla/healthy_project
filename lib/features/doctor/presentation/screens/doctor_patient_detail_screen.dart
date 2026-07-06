import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../laboratory/domain/entities/lab_result_entry.dart';
import '../../../medical_records/domain/entities/medical_record_entry.dart';
import '../../../prescriptions/domain/entities/prescription_entry.dart';
import '../../domain/entities/patient_summary.dart';
import '../cubit/patient_detail_cubit.dart';
import '../cubit/patient_detail_state.dart';
import '../dialogs/add_lab_result_dialog.dart';
import '../dialogs/add_medical_record_dialog.dart';
import '../dialogs/add_prescription_dialog.dart';

class DoctorPatientDetailScreen extends StatelessWidget {
  const DoctorPatientDetailScreen({super.key, required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientDetailCubit(patientId: patientId),
      child: const _PatientDetailView(),
    );
  }
}

class _PatientDetailView extends StatefulWidget {
  const _PatientDetailView();

  @override
  State<_PatientDetailView> createState() => _PatientDetailViewState();
}

class _PatientDetailViewState extends State<_PatientDetailView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onAddPressed(BuildContext context) {
    final cubit = context.read<PatientDetailCubit>();
    switch (_tabController.index) {
      case 0:
        showAddMedicalRecordDialog(context, cubit);
        break;
      case 1:
        showAddPrescriptionDialog(context, cubit);
        break;
      case 2:
        showAddLabResultDialog(context, cubit);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientDetailCubit, PatientDetailState>(
      builder: (context, state) {
        final patient = state.patient;
        if (patient == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              leading: IconButton(
                tooltip: 'رجوع',
                onPressed: () => context.go(AppRoutes.doctorPatients),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            body: const AppEmptyState(
              title: 'تعذر إيجاد بيانات المريض',
              icon: Icons.person_off_rounded,
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'رجوع',
              onPressed: () => context.go(AppRoutes.doctorPatients),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            title: Text(patient.name),
            bottom: TabBar(
              controller: _tabController,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700),
              tabs: [
                Tab(text: 'السجل الطبي (${state.medicalRecords.length})'),
                Tab(text: 'الوصفات (${state.prescriptions.length})'),
                Tab(text: 'التحاليل (${state.labResults.length})'),
              ],
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: _PatientInfoCard(patient: patient),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _MedicalRecordsTab(records: state.medicalRecords),
                    _PrescriptionsTab(prescriptions: state.prescriptions),
                    _LabResultsTab(results: state.labResults),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _onAddPressed(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text('إضافة'),
          ),
        );
      },
    );
  }
}

class _PatientInfoCard extends StatelessWidget {
  const _PatientInfoCard({required this.patient});

  final PatientSummary patient;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(
              patient.initials,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${patient.name} · ${patient.age}',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${patient.gender} · فصيلة ${patient.bloodType} · ${patient.phone}',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'أمراض مزمنة: ${patient.chronicDiseases}',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  'حساسية: ${patient.allergies}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicalRecordsTab extends StatelessWidget {
  const _MedicalRecordsTab({required this.records});

  final List<MedicalRecordEntry> records;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const AppEmptyState(
        title: 'لا توجد سجلات طبية بعد',
        message: 'اضغط زر الإضافة لتسجيل زيارة جديدة.',
        icon: Icons.assignment_outlined,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      itemCount: records.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final record = records[index];
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      record.diagnosis,
                      style: AppTextStyles.titleMedium,
                    ),
                  ),
                  Text(record.visitDate, style: AppTextStyles.bodyMedium),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${record.doctorName} · ${record.specialty} · ${record.hospital}',
                style: AppTextStyles.bodyMedium,
              ),
              if (record.symptoms.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text('الأعراض: ${record.symptoms}',
                    style: AppTextStyles.bodyMedium),
              ],
              if (record.doctorNotes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text('ملاحظات: ${record.doctorNotes}',
                    style: AppTextStyles.bodyMedium),
              ],
              if (record.vitals.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: record.vitals
                      .map(
                        (vital) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Text(
                            '${vital.$1}: ${vital.$2}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _PrescriptionsTab extends StatelessWidget {
  const _PrescriptionsTab({required this.prescriptions});

  final List<PrescriptionEntry> prescriptions;

  @override
  Widget build(BuildContext context) {
    if (prescriptions.isEmpty) {
      return const AppEmptyState(
        title: 'لا توجد وصفات بعد',
        message: 'اضغط زر الإضافة لكتابة وصفة جديدة.',
        icon: Icons.medication_outlined,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      itemCount: prescriptions.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final prescription = prescriptions[index];
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      prescription.doctorName,
                      style: AppTextStyles.titleMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (prescription.isActive
                              ? AppColors.success
                              : AppColors.textGrey)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Text(
                      prescription.isActive ? 'نشطة' : 'منتهية',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 12,
                        color: prescription.isActive
                            ? AppColors.success
                            : AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'من ${prescription.issueDate} حتى ${prescription.expiryDate}',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              ...prescription.medicines.map(
                (medicine) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Text(
                    '• ${medicine.name} — ${medicine.dose}، '
                    '${medicine.frequency}، ${medicine.duration}',
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ),
              if (prescription.notes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'ملاحظات: ${prescription.notes}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _LabResultsTab extends StatelessWidget {
  const _LabResultsTab({required this.results});

  final List<LabResultEntry> results;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const AppEmptyState(
        title: 'لا توجد نتائج تحاليل بعد',
        message: 'اضغط زر الإضافة لتسجيل نتيجة تحليل جديدة.',
        icon: Icons.science_outlined,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final result = results[index];
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      result.testName,
                      style: AppTextStyles.titleMedium,
                    ),
                  ),
                  Text(result.testDate, style: AppTextStyles.bodyMedium),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(result.labName, style: AppTextStyles.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(result.summary, style: AppTextStyles.bodyMedium),
              if (result.rows.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                ...result.rows.map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            row.name,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                        Text(
                          '${row.value}  (${row.normalRange})',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: row.isNormal
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (result.recommendation.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'التوصية: ${result.recommendation}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
