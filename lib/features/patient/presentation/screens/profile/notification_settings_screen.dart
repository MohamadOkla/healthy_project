import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go(AppRoutes.patientProfile),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('إعدادات الإشعارات'),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              SwitchListTile(
                value: state.appointmentNotifications,
                onChanged: cubit.toggleAppointmentNotifications,
                title: const Text('إشعارات المواعيد'),
                secondary: const Icon(Icons.calendar_month_rounded),
              ),
              SwitchListTile(
                value: state.laboratoryNotifications,
                onChanged: cubit.toggleLaboratoryNotifications,
                title: const Text('إشعارات نتائج التحاليل'),
                secondary: const Icon(Icons.science_rounded),
              ),
              SwitchListTile(
                value: state.prescriptionNotifications,
                onChanged: cubit.togglePrescriptionNotifications,
                title: const Text('إشعارات الوصفات'),
                secondary: const Icon(Icons.medication_rounded),
              ),
              SwitchListTile(
                value: state.generalNotifications,
                onChanged: cubit.toggleGeneralNotifications,
                title: const Text('إشعارات عامة'),
                secondary: const Icon(Icons.notifications_rounded),
              ),
              SwitchListTile(
                value: state.appointmentReminder,
                onChanged: cubit.toggleAppointmentReminder,
                title: const Text('تذكير قبل الموعد'),
                secondary: const Icon(Icons.alarm_rounded),
              ),
            ],
          );
        },
      ),
    );
  }
}
