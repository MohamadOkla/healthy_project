import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/current_patient.dart';
import '../../data/local_appointments_repository.dart';
import '../models/appointment_status.dart';
import '../models/appointment_ui_model.dart';
import 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit({LocalAppointmentsRepository? repository})
      : _repository = repository ?? LocalAppointmentsRepository(),
        super(AppointmentsState(appointments: [
          ...(repository ?? LocalAppointmentsRepository())
              .load()
              .where((item) => item.patientId == currentPatientId),
        ])) {
    _repositorySubscription = _repository.changes.listen((items) {
      if (!isClosed) _setAppointments(items);
    });
  }

  final LocalAppointmentsRepository _repository;
  late final StreamSubscription<List<AppointmentUiModel>>
      _repositorySubscription;

  void _setAppointments(List<AppointmentUiModel> items) => emit(
        state.copyWith(appointments: [
          ...items.where((item) => item.patientId == currentPatientId),
        ]),
      );

  Future<bool> cancelByDoctor(String appointmentId, String doctorId) async {
    final canceled = await _repository.cancelByDoctor(appointmentId, doctorId);
    if (canceled) _setAppointments(_repository.load());
    return canceled;
  }

  @override
  Future<void> close() async {
    await _repositorySubscription.cancel();
    await super.close();
  }

  void changeStatus(AppointmentStatus status) {
    emit(state.copyWith(selectedStatus: status));
  }

  void searchAppointments(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void applyFilters({
    required AppointmentStatus status,
    String? specialty,
    String? date,
  }) {
    emit(
      state.copyWith(
        selectedStatus: status,
        specialtyFilter: specialty,
        dateFilter: date,
        clearSpecialtyFilter: specialty == null,
        clearDateFilter: date == null,
      ),
    );
  }

  void clearFilters() {
    emit(
      state.copyWith(
        searchQuery: '',
        selectedStatus: AppointmentStatus.confirmed,
        clearSpecialtyFilter: true,
        clearDateFilter: true,
      ),
    );
  }

  List<String> get specialties {
    return state.appointments
        .map((appointment) => appointment.specialty)
        .toSet()
        .toList(growable: false);
  }

  List<String> get dates {
    return state.appointments
        .map((appointment) => appointment.date)
        .toSet()
        .toList(growable: false);
  }
}
