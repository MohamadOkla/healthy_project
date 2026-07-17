import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/current_patient.dart';
import '../../../medical_records/data/repositories/medical_records_repository_impl.dart';
import '../widgets/patient_list_view.dart';
import '../widgets/patient_list_card.dart';
import '../../../../core/constants/app_routes.dart';

class MedicalRecordsScreen extends StatelessWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = MedicalRecordsRepositoryImpl()
        .getRecordsForPatient(currentPatientId);

    return PatientListView(
      title: 'السجل الطبي',
      selectedIndex: 0,
      emptyTitle: 'لا توجد سجلات طبية بعد',
      emptyMessage: 'ستظهر هنا زياراتك الطبية بعد أن يضيفها طبيبك.',
      emptyIcon: Icons.assignment_outlined,
      children: records
          .map(
            (record) => PatientListCard(
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
