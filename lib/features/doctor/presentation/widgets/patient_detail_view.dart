import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../cubit/patient_detail_cubit.dart';
import '../cubit/patient_detail_state.dart';
import 'patient_info_card.dart';
import 'medical_records_tab.dart';
import 'prescriptions_tab.dart';
import 'lab_results_tab.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../dialogs/add_prescription_dialog.dart';
import '../dialogs/add_medical_record_dialog.dart';
import '../dialogs/add_lab_result_dialog.dart';

class PatientDetailView extends StatefulWidget {
  const PatientDetailView();

  @override
  State<PatientDetailView> createState() => _PatientDetailViewState();
}

class _PatientDetailViewState extends State<PatientDetailView>
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
                child: PatientInfoCard(patient: patient),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    MedicalRecordsTab(records: state.medicalRecords),
                    PrescriptionsTab(prescriptions: state.prescriptions),
                    LabResultsTab(results: state.labResults),
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
