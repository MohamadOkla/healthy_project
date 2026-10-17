import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/current_patient.dart';
import '../../../appointments/data/local_appointments_repository.dart';
import '../../../appointments/presentation/models/appointment_status.dart';
import '../../../appointments/presentation/models/appointment_ui_model.dart';
import '../../../medical_records/data/repositories/medical_records_repository_impl.dart';
import '../../../medical_records/domain/entities/medical_record_entry.dart';
import '../../../medical_records/domain/repositories/medical_records_repository.dart';
import '../../../notifications/data/repositories/notifications_repository_impl.dart';
import '../../../notifications/domain/entities/app_notification.dart';
import '../../../notifications/domain/repositories/notifications_repository.dart';
import '../../../prescriptions/data/repositories/prescriptions_repository_impl.dart';
import '../../../prescriptions/domain/repositories/prescriptions_repository.dart';
import '../models/appointment_model.dart';
import '../models/health_summary_model.dart';
import '../models/quick_action_model.dart';
import 'patient_dashboard_state.dart';

class PatientDashboardCubit extends Cubit<PatientDashboardState> {
  factory PatientDashboardCubit({
    PrescriptionsRepository? prescriptionsRepository,
    MedicalRecordsRepository? medicalRecordsRepository,
    NotificationsRepository? notificationsRepository,
    LocalAppointmentsRepository? appointmentsRepository,
  }) {
    return PatientDashboardCubit._(
      prescriptionsRepository:
          prescriptionsRepository ?? PrescriptionsRepositoryImpl(),
      medicalRecordsRepository:
          medicalRecordsRepository ?? MedicalRecordsRepositoryImpl(),
      notificationsRepository:
          notificationsRepository ?? NotificationsRepositoryImpl(),
      appointmentsRepository:
          appointmentsRepository ?? LocalAppointmentsRepository(),
    );
  }

  PatientDashboardCubit._({
    required PrescriptionsRepository prescriptionsRepository,
    required MedicalRecordsRepository medicalRecordsRepository,
    required NotificationsRepository notificationsRepository,
    required LocalAppointmentsRepository appointmentsRepository,
  })  : _prescriptionsRepository = prescriptionsRepository,
        _medicalRecordsRepository = medicalRecordsRepository,
        _notificationsRepository = notificationsRepository,
        _appointmentsRepository = appointmentsRepository,
        super(
          PatientDashboardState(
            healthSummary: _buildSummary(
              prescriptionsRepository,
              medicalRecordsRepository,
              notificationsRepository,
              appointmentsRepository.load(),
            ),
            quickActions: [
              QuickActionModel(
                title: 'مواعيدي',
                icon: Icons.calendar_month_rounded,
                route: AppRoutes.patientAppointments,
              ),
              QuickActionModel(
                title: 'السجل الطبي',
                icon: Icons.assignment_rounded,
                route: AppRoutes.patientMedicalRecords,
              ),
              QuickActionModel(
                title: 'الوصفات',
                icon: Icons.medication_rounded,
                route: AppRoutes.patientPrescriptions,
              ),
              QuickActionModel(
                title: 'التحاليل',
                icon: Icons.science_rounded,
                route: AppRoutes.patientLaboratory,
              ),
            ],
            upcomingAppointment:
                _upcomingAppointment(appointmentsRepository.load()),
          ),
        ) {
    _appointmentsSubscription = _appointmentsRepository.changes.listen((_) {
      if (!isClosed) refresh();
    });
  }

  final PrescriptionsRepository _prescriptionsRepository;
  final MedicalRecordsRepository _medicalRecordsRepository;
  final NotificationsRepository _notificationsRepository;
  final LocalAppointmentsRepository _appointmentsRepository;
  late final StreamSubscription<List<AppointmentUiModel>>
      _appointmentsSubscription;

  @override
  Future<void> close() async {
    await _appointmentsSubscription.cancel();
    await super.close();
  }

  void refresh() {
    final appointments = _appointmentsRepository.load();
    final upcomingAppointment = _upcomingAppointment(appointments);
    emit(state.copyWith(
      healthSummary: _buildSummary(
        _prescriptionsRepository,
        _medicalRecordsRepository,
        _notificationsRepository,
        appointments,
      ),
      upcomingAppointment: upcomingAppointment,
      clearUpcomingAppointment: upcomingAppointment == null,
    ));
  }

  static AppointmentModel? _upcomingAppointment(
    List<AppointmentUiModel> appointments,
  ) {
    final upcoming = appointments
        .where((appointment) =>
            appointment.patientId == currentPatientId &&
            appointment.status == AppointmentStatus.confirmed &&
            appointment.startAt != null &&
            appointment.startAt!.isAfter(DateTime.now()))
        .toList()
      ..sort((a, b) => a.startAt!.compareTo(b.startAt!));
    return upcoming.isEmpty
        ? null
        : AppointmentModel(appointment: upcoming.first);
  }

  static HealthSummaryModel _buildSummary(
    PrescriptionsRepository prescriptions,
    MedicalRecordsRepository medicalRecords,
    NotificationsRepository notifications,
    List<AppointmentUiModel> appointments,
  ) {
    final lastVisit = _lastVisitLabel(
      medicalRecords.getRecordsForPatient(currentPatientId),
    );
    final upcomingAppointments = appointments.where((appointment) {
      final startAt = appointment.startAt;
      return appointment.patientId == currentPatientId &&
          appointment.status == AppointmentStatus.confirmed &&
          startAt != null &&
          startAt.isAfter(DateTime.now());
    }).length;
    final activePrescriptions = prescriptions
        .getPrescriptionsForPatient(currentPatientId)
        .where((prescription) => prescription.isActive)
        .length;
    final unreadResults = notifications
        .getNotificationsForPatient(currentPatientId)
        .where((notification) =>
            notification.type == AppNotificationType.labResult &&
            !notification.isRead)
        .length;

    return HealthSummaryModel(
      lastVisit: lastVisit,
      upcomingAppointments: upcomingAppointments,
      activePrescriptions: activePrescriptions,
      newResults: unreadResults,
    );
  }

  static String _lastVisitLabel(List<MedicalRecordEntry> records) {
    final now = DateTime.now();
    final dated = records
        .where((record) =>
            record.patientId == currentPatientId &&
            record.occurredAt != null &&
            !record.occurredAt!.isAfter(now))
        .toList()
      ..sort((a, b) => b.occurredAt!.compareTo(a.occurredAt!));
    if (dated.isNotEmpty) {
      final days = now.difference(dated.first.occurredAt!).inDays;
      if (days == 0) return 'اليوم';
      if (days == 1) return 'منذ يوم واحد';
      if (days == 2) return 'منذ يومين';
      if (days <= 10) return 'منذ $days أيام';
      return 'منذ $days يومًا';
    }

    for (final record in records) {
      if (record.patientId == currentPatientId &&
          record.visitDate.trim().isNotEmpty) {
        return record.visitDate.trim();
      }
    }
    return 'لا توجد زيارات سابقة';
  }
}
