import 'package:equatable/equatable.dart';

import '../models/appointment_model.dart';
import '../models/health_summary_model.dart';
import '../models/quick_action_model.dart';

class PatientDashboardState extends Equatable {
  const PatientDashboardState({
    required this.healthSummary,
    required this.quickActions,
    this.upcomingAppointment,
    this.isLoading = false,
  });

  final HealthSummaryModel healthSummary;
  final List<QuickActionModel> quickActions;
  final AppointmentModel? upcomingAppointment;
  final bool isLoading;

  PatientDashboardState copyWith({
    HealthSummaryModel? healthSummary,
    List<QuickActionModel>? quickActions,
    AppointmentModel? upcomingAppointment,
    bool clearUpcomingAppointment = false,
    bool? isLoading,
  }) {
    return PatientDashboardState(
      healthSummary: healthSummary ?? this.healthSummary,
      quickActions: quickActions ?? this.quickActions,
      upcomingAppointment: clearUpcomingAppointment
          ? null
          : upcomingAppointment ?? this.upcomingAppointment,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        healthSummary,
        quickActions,
        upcomingAppointment,
        isLoading,
      ];
}
