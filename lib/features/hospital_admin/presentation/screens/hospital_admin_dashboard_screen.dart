import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/hospital_admin_dashboard_cubit.dart';
import '../widgets/hospital_admin_bottom_navigation.dart';
import '../widgets/admin_dashboard_body.dart';

class HospitalAdminDashboardScreen extends StatelessWidget {
  const HospitalAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HospitalAdminDashboardCubit(),
      child: const Scaffold(
        body: SafeArea(child: AdminDashboardBody()),
        bottomNavigationBar: HospitalAdminBottomNavigation(selectedIndex: 0),
      ),
    );
  }
}
