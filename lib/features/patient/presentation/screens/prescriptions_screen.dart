import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/current_patient.dart';
import '../../../prescriptions/data/repositories/prescriptions_repository_impl.dart';
import '../widgets/patient_list_view.dart';
import '../widgets/patient_list_card.dart';
import '../../../../core/constants/app_routes.dart';

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prescriptions = PrescriptionsRepositoryImpl()
        .getPrescriptionsForPatient(currentPatientId);

    return PatientListView(
      title: 'الوصفات',
      selectedIndex: 0,
      emptyTitle: 'لا توجد وصفات بعد',
      emptyMessage: 'ستظهر هنا الوصفات التي يصدرها طبيبك.',
      emptyIcon: Icons.medication_outlined,
      children: prescriptions
          .map(
            (prescription) => PatientListCard(
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
