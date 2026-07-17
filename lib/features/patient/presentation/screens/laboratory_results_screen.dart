import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/current_patient.dart';
import '../../../laboratory/data/repositories/laboratory_repository_impl.dart';
import '../widgets/patient_list_view.dart';
import '../widgets/patient_list_card.dart';
import '../../../../core/constants/app_routes.dart';

class LaboratoryResultsScreen extends StatelessWidget {
  const LaboratoryResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final results =
        LaboratoryRepositoryImpl().getResultsForPatient(currentPatientId);

    return PatientListView(
      title: 'التحاليل',
      selectedIndex: 0,
      emptyTitle: 'لا توجد نتائج تحاليل بعد',
      emptyMessage: 'ستظهر هنا نتائج التحاليل المخبرية عند توفرها.',
      emptyIcon: Icons.science_outlined,
      children: results
          .map(
            (result) => PatientListCard(
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
