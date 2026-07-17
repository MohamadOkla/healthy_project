import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/doctor_dashboard_cubit.dart';
import '../widgets/doctor_bottom_navigation.dart';
import '../widgets/doctor_dashboard_body.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorDashboardCubit(),
      child: const Scaffold(
        body: SafeArea(
          child: DoctorDashboardBody(),
        ),
        bottomNavigationBar: DoctorBottomNavigation(selectedIndex: 0),
      ),
    );
  }
}
