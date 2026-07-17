import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/patient_detail_cubit.dart';
import '../widgets/patient_detail_view.dart';

class DoctorPatientDetailScreen extends StatelessWidget {
  const DoctorPatientDetailScreen({super.key, required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientDetailCubit(patientId: patientId),
      child: const PatientDetailView(),
    );
  }
}
